//
//  AppDelegate.m
//  TestApp
//
//  Created by Keith Feldman on 1/28/16.
//  CCopyright © 2016 Kount Inc. All rights reserved.
//

#import "KDataCollector_Internal.h"
#import "AppDelegate.h"
#import "Common.h"
#import "MainViewController.h"
#import "CollectViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    // Configure the defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kSettingsMerchantIDKey : kSettingsMerchantIDDefault, kSettingsServerKey : kSettingsServer, kSettingsTimeoutKey: kSettingsTimeoutDefault}];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Create the view controllers and window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *controller = [[MainViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    // Configure the data collector
    [[KDataCollector sharedCollector] setDebug:YES];
    [[KDataCollector sharedCollector] setMerchantID:[[NSUserDefaults standardUserDefaults] stringForKey:kSettingsMerchantIDKey]];
    [[KDataCollector sharedCollector] setEnvironment:KEnvironmentTest];
    [[KDataCollector sharedCollector] setServer:[[NSUserDefaults standardUserDefaults] stringForKey:kSettingsServerKey]];
    [[KDataCollector sharedCollector] setTimeoutInMS:[[NSUserDefaults standardUserDefaults] integerForKey:kSettingsTimeoutKey]];
    return YES;
}

@end
