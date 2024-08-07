#import "CheckoutViewController.h"
@import KountDataCollector;
@implementation CheckoutViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Create a unique Session ID
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidStrRef = CFUUIDCreateString(nil, uuidRef);
    CFRelease(uuidRef);
    NSString *sessionID = [(__bridge NSString *)uuidStrRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStrRef);
    self.textView.text = @"Collection Starting\n\n";
    self.textView.text = [self.textView.text stringByAppendingFormat:@"Session ID:\n%@\n\n", sessionID];
    [[KDataCollector sharedCollector] collectForSession:sessionID completion:^(NSString * _Nonnull sessionID, BOOL success, NSError * _Nullable error) {
        if (success) {
            self.textView.text = [self.textView.text stringByAppendingString:@"Collection Successful"];
            NSLog(@"Collection Status %@", [KountAnalyticsViewController getKDataCollectionStatus]);
        }
        else {
            self.textView.text = [self.textView.text stringByAppendingString:@"Collection Failed\n\n"];
            self.textView.text = [self.textView.text stringByAppendingString:[error description]];
            NSLog(@"Collection Status %@", [KountAnalyticsViewController getKDataCollectionError]);
        }
    }];
}

- (IBAction)done:(id)sender 
{
    [self.delegate checkoutViewControllerDidFinish:self];
}

@end
