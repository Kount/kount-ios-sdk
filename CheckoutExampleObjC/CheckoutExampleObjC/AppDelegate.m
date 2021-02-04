#import "AppDelegate.h"
#import "KDataCollector.h"
#import "KountAnalyticsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //// Configure the Data Collector
    //
    NSString *sessionID = nil;
    [[KDataCollector sharedCollector] setDebug:YES];
    // TODO Set your Merchant ID
    [[KDataCollector sharedCollector] setMerchantID:0];
    // TODO Set the location collection configuration
    [[KDataCollector sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigRequestPermission];
    // For a released app, you'll want to set this to KEnvironmentProduction
    [[KDataCollector sharedCollector] setEnvironment:KEnvironmentTest];
    KountAnalyticsViewController *dataCollectionObject = [[KountAnalyticsViewController alloc] init];
    [dataCollectionObject setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    // To collect Analytics Data, you'll want set this analyticsData to YES or else NO
    BOOL analyticsData = YES;
    [dataCollectionObject collect:sessionID analyticsSwitch:analyticsData completion:^(NSString * _Nonnull sessionID, BOOL success, NSError * _Nullable error) {
        if(success) {
            NSLog(@"Collection Successful");
        }
        else {
            if (error != nil) {
                NSLog(@"Collection failed with error:%@",error.description);
            }
            else {
                NSLog(@"Collection failed without error");
            }
        }
    }];
    
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    if(@available(*, iOS 12.4.7)) {
        KountAnalyticsViewController *backgroundTaskObject = [[KountAnalyticsViewController alloc] init];
        [backgroundTaskObject registerBackgroundTask];
    }
}

@end
