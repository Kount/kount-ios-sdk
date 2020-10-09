//
//  KountAnalyticsViewController.h
//  KountDataCollector
//
//  Created by Vamsi Krishna on 07/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "KDataCollector.h"

NS_ASSUME_NONNULL_BEGIN

@interface KountAnalyticsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {

}

+ (NSString *)getAppSessionID;
- (BOOL)checkIsDeviceJailbroken;
- (void)appear;
- (void)disappear;
- (int64_t)getEpochTime;
- (void)storeDeletionTime;
- (void)storeStartingTime;
- (void)msDifferenceBetweenCharacter;
- (void)allMsDifferenceBetweenKeys;
- (void)assignInputData;
- (void)collectBatteryData;
- (void)getBatteryState;
- (void)getBatteryLevel;
- (void)getLowPowerModeStatus;
- (void)didChangeBatteryState:(NSNotification *)notification;
- (void)didChangeBatteryLevel:(NSNotification *)notification;
- (void)didChangePowerMode:(NSNotification *)notification;
- (void)assignBatteryData;
- (void)update;
- (void)collect:(NSString *)sessionID analyticsSwitch:(BOOL)analyticsData completion:(nullable void (^)(NSString *_Nonnull sessionID, NSError *_Nullable error))completionBlock;
- (NSString *)getSessionID;
- (void)createJsonObjectFormat;
- (void)storeLogInEvents:(BOOL)logInStatus;
- (void)assignFormData;
- (void)storeButtonEvents:(UIView *)myView touchesOnButton:(UITouch *)touches;
- (void)setEnvironmentForAnalytics:(KEnvironment)env;
- (void)registerBackgroundTask;
- (void)appInBackground;
@end

NS_ASSUME_NONNULL_END

