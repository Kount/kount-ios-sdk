//
//  CollectViewController.m
//  TestApp
//
//  Created by Keith Feldman on 1/28/16.
//  CCopyright © 2016 Kount Inc. All rights reserved.
//

#import "CollectViewController.h"
#import "KDataCollector_Internal.h"

// Avoid the certificate validation on the simulator
#if (TARGET_IPHONE_SIMULATOR)
@implementation NSURLRequest(DataController) 
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host 
{ 
    return YES; 
} 
@end 
#endif

#pragma mark

//
// Table View Sections and Rows
//

#define CollectorViewControllerSectionCollectors 0
#define CollectorViewControllerSectionLog 1

@interface CollectViewController () <KDataCollectorDebugDelegate>

@property (strong) UITextView *textView;
@property (strong) NSMutableArray *logMessages;
@property (strong) NSMutableArray *collectors;
@property (strong) UITableViewCell *sizePrototypeCell;
@property (strong) NSString *collectionTime;

@end

@implementation CollectViewController

#pragma mark Managing the detail item

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.logMessages = [NSMutableArray array];
    self.collectors = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated  
{
    [super viewWillAppear:animated];
    switch (self.locationCollectorConfig) {
        case KLocationCollectorConfigSkip:
            self.navigationItem.title = @"Collect w/o Location";
            break;
        case KLocationCollectorConfigRequestPermission:
            self.navigationItem.title = @"Collect w/ Location (Request)";
            break;
        case KLocationCollectorConfigPassive:
            self.navigationItem.title = @"Collect w/ Location (Passive)";
            break;
    }
    // Create a table cell to be used to estimate row height for log messages
    self.sizePrototypeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.sizePrototypeCell.textLabel.numberOfLines = 0;
    self.sizePrototypeCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.sizePrototypeCell.textLabel.font = [UIFont systemFontOfSize:13.0];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    [self appendLogMessage:@"#BEGIN"];
    
    // Create a unique Session ID
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidStrRef = CFUUIDCreateString(nil, uuidRef);
    CFRelease(uuidRef);
    NSString *sessionId = [(__bridge NSString *)uuidStrRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStrRef);
    
    [[KDataCollector sharedCollector] setLocationCollectorConfig:self.locationCollectorConfig];
    [[KDataCollector sharedCollector] collectForSession:sessionId completion:^(NSString *sessionID, BOOL success, NSError *error) {
        if (success)  {
            [self appendLogMessage:[NSString stringWithFormat:@"#END (✓) %@", self.collectionTime]];
        }
        else {
            [self appendLogMessage:@"#END (✗)"];
        }
        if (error) {
            [self appendLogMessage:[NSString stringWithFormat:@"#ERROR (%ld): %@", (long)[error code], [error localizedDescription]]];
        }
    } debugDelegate:self];
}

#pragma mark Helper Methods

- (void)appendLogMessage:(NSString *)message 
{
    [self.logMessages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:CollectorViewControllerSectionLog]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark Collector Delegate

- (void)collectorDebugMessage:(NSString *)message 
{
    [self appendLogMessage:message];
    NSRange range = [message rangeOfString:@"Collection time"];
    if (range.location != NSNotFound) {
        self.collectionTime = [message substringFromIndex:(range.location)];
    }
}

- (void)collectorStarted:(NSString *)collectorName 
{
    [self.collectors addObject:collectorName];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.collectors.count - 1) inSection:CollectorViewControllerSectionCollectors]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)collectorDone:(NSString *)collectorName success:(BOOL)success error:(NSError *)error 
{
    NSInteger index = [self.collectors indexOfObject:collectorName];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:CollectorViewControllerSectionCollectors]];
    cell.detailTextLabel.text = success ? @"✓" : @"✗";
    [self appendLogMessage:[NSString stringWithFormat:@"%@ %@", success ? @"✓" : @"✗", collectorName]];
    if (error) {
        [self appendLogMessage:[NSString stringWithFormat:@"#✗ ERROR in %@ (%ld): %@", collectorName, (long)[error code], [error localizedDescription]]];
    }
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == CollectorViewControllerSectionLog) {
        [self configureLogMessageCell:self.sizePrototypeCell indexPath:indexPath];
        CGSize size = [self.sizePrototypeCell.textLabel sizeThatFits:self.sizePrototypeCell.contentView.bounds.size];
        return size.height + 10.0;
    }
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == CollectorViewControllerSectionCollectors) {
        return self.collectors.count;
    } 
    else if (section == CollectorViewControllerSectionLog) {
        return self.logMessages.count;
    }
    return 0;
}

- (void)configureLogMessageCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath 
{
    NSString *logMessage = [self.logMessages objectAtIndex:indexPath.row];
    if ([[logMessage substringToIndex:1] isEqualToString:@"#"]) {
        cell.textLabel.text = [logMessage substringFromIndex:1];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", logMessage];
        cell.textLabel.textColor = [UIColor grayColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = nil;
    if (indexPath.section == CollectorViewControllerSectionCollectors) {
        NSString *cellIdentifier = @"CollectorCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        NSString *collectorName = [self.collectors objectAtIndex:indexPath.row];
        cell.textLabel.text = collectorName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == CollectorViewControllerSectionLog) {
        NSString *cellIdentifier = @"LogCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        }
        [self configureLogMessageCell:cell indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == CollectorViewControllerSectionCollectors) {
        return @"Collectors";
    }
    else if (section == CollectorViewControllerSectionLog) {
        return @"Log (newest at top)";
    }
    return nil;
}

@end
