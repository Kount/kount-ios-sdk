#import "AppDelegate.h"
#import "KDataCollector.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    //// Configure the Data Collector
    //
    [[KDataCollector sharedCollector] setDebug:YES];
    // TODO Set your Merchant ID
    [[KDataCollector sharedCollector] setMerchantID:0]; 
    // TODO Set the location collection configuration
    [[KDataCollector sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigRequestPermission];
    // For a released app, you'll want to set this to KEnvironmentProduction
    [[KDataCollector sharedCollector] setEnvironment:KEnvironmentTest];
    
    return YES;
}

@end
