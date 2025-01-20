//
//  MainViewController.m
//  TestApp
//
//  Created by Keith Feldman on 1/28/16.
//  CCopyright © 2016 Kount Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "KDataCollector_Internal.h"
#import "MainViewController.h"
#import "CollectViewController.h"
#import "Common.h"

//
// Table View Sections and Rows
//

#define MainViewControllerSectionCollect 0
#define MainViewControllerSectionCollectRowNoLocation 0
#define MainViewControllerSectionCollectRowRequestLocation 1
#define MainViewControllerSectionCollectRowPassiveLocation 2

#define MainViewControllerSectionConfig 1
#define MainViewControllerSectionConfigRowMerchant 0
#define MainViewControllerSectionConfigRowURL 1
#define MainViewControllerSectionConfigRowTimeout 2

#define MainViewControllerSectionInfo 2
#define MainViewControllerSectionInfoRowSDKVersion 0
#define MainViewControllerSectionInfoRowOSVersion 1
#define MainViewControllerSectionInfoRowAppBuilt 2
#define MainViewControllerSectionInfoRowiOSSDKVersion 3

@implementation MainViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.title = @"Test App";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x603912);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    // Reload section to update location authorization status
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark Helper Methods

- (NSString *)buildDateString 
{
    NSString *systemDateString = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:__DATE__] , [NSString stringWithUTF8String:__TIME__] ];
    
    // Convert to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLL d yyyy HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:systemDateString];
    
    // Return a more readable date string
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormat stringFromDate:date];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == MainViewControllerSectionCollect) {
        return 3;
    }
    else if (section == MainViewControllerSectionConfig) {
        return 3;
    }
    else if (section == MainViewControllerSectionInfo) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.minimumScaleFactor = 0.5;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    if (indexPath.section == MainViewControllerSectionCollect) {
        if (indexPath.row == MainViewControllerSectionCollectRowNoLocation) {
            cell.textLabel.text = @"Collect without Location";
        }
        else if (indexPath.row == MainViewControllerSectionCollectRowRequestLocation) {
            cell.textLabel.text = @"Collect with Location + Request";
        }
        else if (indexPath.row == MainViewControllerSectionCollectRowPassiveLocation) {
            cell.textLabel.text = @"Collect with Location (Passive)";
        }
        cell.detailTextLabel.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = self.view.tintColor;
    }
    if (indexPath.section == MainViewControllerSectionConfig) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == MainViewControllerSectionConfigRowMerchant) {
            cell.textLabel.text = @"Merchant";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kSettingsMerchantIDKey]];
        }
        else if (indexPath.row == MainViewControllerSectionConfigRowURL) {
            cell.textLabel.text = @"URL";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSettingsServerKey];
        }
        else if (indexPath.row == MainViewControllerSectionConfigRowTimeout) {
            cell.textLabel.text = @"Timeout";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsTimeoutKey]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.section == MainViewControllerSectionInfo) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        if (indexPath.row == MainViewControllerSectionInfoRowSDKVersion) {
            cell.textLabel.text = @"Kount SDK Version";
            cell.detailTextLabel.text = KDataCollectorVersion;
        }
        if (indexPath.row == MainViewControllerSectionInfoRowOSVersion) {
            cell.textLabel.text = @"Device iOS";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
        }
        if (indexPath.row == MainViewControllerSectionInfoRowAppBuilt) {
            cell.textLabel.text = @"Test App Built";
            cell.detailTextLabel.text = [self buildDateString];
        }
        if (indexPath.row == MainViewControllerSectionInfoRowiOSSDKVersion) {
            cell.textLabel.text = @"iOS SDK";
            cell.detailTextLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUILD_IOSSDK"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == MainViewControllerSectionCollect) {
        CollectViewController *controller = [[CollectViewController alloc] initWithStyle:UITableViewStyleGrouped];
        switch (indexPath.row) {
            case MainViewControllerSectionCollectRowNoLocation:
                controller.locationCollectorConfig = KLocationCollectorConfigSkip;
                break;
            case MainViewControllerSectionCollectRowRequestLocation:
                controller.locationCollectorConfig = KLocationCollectorConfigRequestPermission;
                break;
            case MainViewControllerSectionCollectRowPassiveLocation:
                controller.locationCollectorConfig = KLocationCollectorConfigPassive;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == MainViewControllerSectionConfig) {
        if (indexPath.row == MainViewControllerSectionConfigRowMerchant) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Merchant ID" message:@"Please enter the Merchant ID" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    //  Handle your cancel button action here
                }];
            
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSString *text = alert.textFields[0].text;
                [[KDataCollector sharedCollector] setMerchantID: text];
                [[NSUserDefaults standardUserDefaults] setObject: text forKey:kSettingsMerchantIDKey];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];

            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSettingsMerchantIDKey];
            }];
            [alert addAction: cancel];
            [alert addAction: okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == MainViewControllerSectionConfigRowURL) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"URL" message:@"Please enter the URL" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    //  Handle your cancel button action here
                }];
            
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSString *text = alert.textFields[0].text;
                [[KDataCollector sharedCollector] setServer:text];
                [[NSUserDefaults standardUserDefaults] setObject:text forKey:kSettingsServerKey];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];

            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSettingsServerKey];
            }];
            [alert addAction: cancel];
            [alert addAction: okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == MainViewControllerSectionConfigRowTimeout) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Timeout" message:@"Please enter the timeout in miliseconds" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    //  Handle your cancel button action here
                }];
            
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSString *text = alert.textFields[0].text;
                [[KDataCollector sharedCollector] setTimeoutInMS:[text intValue]];
                [[NSUserDefaults standardUserDefaults] setInteger:[text intValue] forKey:kSettingsTimeoutKey];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];

            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kSettingsTimeoutKey];
            }];
            [alert addAction: cancel];
            [alert addAction: okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == MainViewControllerSectionCollect) {
        return @"Domo Says: Feed Me Bugs!";
    }
    else if (section == MainViewControllerSectionConfig) {
        return @"Configuration";
    }
    else if (section == MainViewControllerSectionInfo) {
        return @"System Information";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section 
{
    if (section == MainViewControllerSectionCollect) {
        CLAuthorizationStatus auth = [CLLocationManager authorizationStatus];
        switch (auth) {
            case kCLAuthorizationStatusNotDetermined:
                return @"Location Authorization: Not Determined";
            case kCLAuthorizationStatusRestricted:
                return @"Location Authorization: Restricted";
            case kCLAuthorizationStatusDenied:
                return @"Location Authorization: Restricted";
            case kCLAuthorizationStatusAuthorizedAlways:
                return @"Location Authorization: Authorized";
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                return @"Location Authorization: Authorized (When In Use)";
        }
    }
    return nil;
}

@end
