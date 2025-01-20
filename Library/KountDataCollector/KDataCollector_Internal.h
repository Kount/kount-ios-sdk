//
//  KDataCollector_Internal.h
//  KountDataCollector
//
//  Additional parts of KDataCollector exposed for testing purposes
//
//  Created by Keith Feldman on 2/1/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <KountDataCollector/KDataCollector.h>
#import "KCollectorTaskBase.h"

NS_ASSUME_NONNULL_BEGIN

// Block callback for data collection
typedef void (^KDataCollectorCompletionBlock)(NSString *sessionID, BOOL success, NSError *error);

// Collector POST Keys
extern NSString *const KDataCollectorPostKeyLocationLatitude;
extern NSString *const KDataCollectorPostKeyLocationLongitude;
extern NSString *const KDataCollectorPostKeyLocationDate;
extern NSString *const KDataCollectorPostKeySDKVersion;
extern NSString *const KDataCollectorPostKeySDKType;
extern NSString *const KDataCollectorPostKeyMobileModel;
extern NSString *const KDataCollectorPostKeySoftErrors;
extern NSString *const KDataCollectorPostKeyMerchantID;
extern NSString *const KDataCollectorPostKeySessionID;
extern NSString *const KDataCollectorPostKeyOSVersion;
extern NSString *const KDataCollectorPostKeyDeviceCookie;
extern NSString *const KDataCollectorPostKeyOldDeviceCookie;
extern NSString *const KDataCollectorPostKeyCookieUID;
extern NSString *const KDataCollectorPostKeyVendorUID;
extern NSString *const KDataCollectorPostKeyTotalMemory;
extern NSString *const KDataCollectorPostKeyElapsed;
extern NSString *const KDataCollectorPostKeyTimezoneAugust;
extern NSString *const KDataCollectorPostKeyTimezoneFebruary;
extern NSString *const KDataCollectorPostKeyTimezoneCurrent;
extern NSString *const KDataCollectorPostKeyLocalDateTimeEpoch;
extern NSString *const KDataCollectorPostKeyLanguageAndCountry;
extern NSString *const KDataCollectorPostKeyScreenDimensions;

//KIOS-9 :Enhance Timing Metrics
// Timing Metrics POST Keys
extern NSString *const KDataCollectorPostKeyMerchantIDElapsedTime;
extern NSString *const KDataCollectorPostKeySessionIDElapsedTime;
extern NSString *const KDataCollectorPostKeyDeviceCookieElapsedTime;
extern NSString *const KDataCollectorPostKeyOldDeviceCookieElapsedTime;
extern NSString *const KDataCollectorPostKeyLocationLatitudeElapsedTime;
extern NSString *const KDataCollectorPostLocationLongitudeElapsedTime;
extern NSString *const KDataCollectorPostKeyLocationDateElapsedTime;
extern NSString *const KDataCollectorPostKeyLanguageAndCountryElapsedTime;
extern NSString *const KDataCollectorPostKeyMobileModelElapsedTime;
extern NSString *const KDataCollectorPostKeyTimezoneAugustElapsedTime;
extern NSString *const KDataCollectorPostKeyTimezoneFebruaryElapsedTime;
extern NSString *const KDataCollectorPostKeyTimezoneCurrentElapsedTime;
extern NSString *const KDataCollectorPostKeyTotalMemoryElapsedTime;
extern NSString *const KDataCollectorPostKeyLocalDateTimeEpochElapsedTime;
extern NSString *const KDataCollectorPostKeyScreenDimensionsElapsedTime;
extern NSString *const KDataCollectorPostKeySDKVersionElapsedTime;
extern NSString *const KDataCollectorPostKeySDKTypeElapsedTime;
extern NSString *const KDataCollectorPostKeyOSVersionElapsedTime;
extern NSString *const KDataCollectorPostKeySystemCollectorElapsedTime;
extern NSString *const KDataCollectorPostKeyFingerprintCollectorElapsedTime;
extern NSString *const KDataCollectorPostKeyLocationCollectorElapsedTime;

//KIOS-20: ReverseGeoData from iOS Device SDK
extern NSString *const KDataCollectorPostKeyCity;
extern NSString *const KDataCollectorPostKeyState;
extern NSString *const KDataCollectorPostKeyCountry;
extern NSString *const KDataCollectorPostKeyISO;
extern NSString *const KDataCollectorPostKeyPostalCode;
extern NSString *const KDataCollectorPostKeyOrganization;
extern NSString *const KDataCollectorPostKeyStreet;
extern NSString *const KDataCollectorPostKeyReverseGeocodeElapsedTime;

// Soft Error Keys
extern NSString *const KDataCollectorPostSoftErrorKeyPassivelySkipped;
extern NSString *const KDataCollectorPostSoftErrorKeySkipped;
extern NSString *const KDataCollectorPostSoftErrorKeyUnexpected;
extern NSString *const KDataCollectorPostSoftErrorKeyServiceUnavailable;
extern NSString *const KDataCollectorPostSoftErrorKeyPermissionDenied;
extern NSString *const KDataCollectorPostSoftErrorKeyTimeout;
//KIOS-20: ReverseGeoData from iOS Device SDK
extern NSString *const KDataCollectorPostSoftErrorKeyAddressFieldsUnavailable;
extern NSString *const KDataCollectorPostSoftErrorKeyAddressNotCollected;

//KIOS-20: ReverseGeoData from iOS Device SDK
extern NSString *const KDataCollectorPostSoftErrorKeyAddressFieldsUnavailable;
extern NSString *const KDataCollectorPostSoftErrorKeyAddressNotCollected;

// Collector Names
extern NSString *const KDataCollectorInternalNameLocation;
extern NSString *const KDataCollectorInternalNameFingerprint;
extern NSString *const KDataCollectorInternalNameSystem;

// Other Constants
extern NSString *const KDataCollectorPostMobileEndpoint;
extern NSString *const KDataCollectorPostEmptyBody;

// Environment
extern int const KEnvironmentQA;


@class KCollectorTaskBase;

#pragma mark Debug Delegate

// Delegate exposed for internal testing purposes
@protocol KDataCollectorDebugDelegate <NSObject>

- (void)collectorDebugMessage:(NSString *)message;
- (void)collectorDone:(NSString *)collectorName success:(BOOL)success error:(NSError *)error;
- (void)collectorStarted:(NSString *)collectorName;

@end

#pragma mark Exposed Methods

// Methods exposed for internal testing purposes
@interface KDataCollector ()

// This method takes an additional debugDelegate parameter to get debug output for debugging and testing purposes
- (void)collectForSession:(NSString *)sessionID completion:(nullable KDataCollectorCompletionBlock)completionBlock debugDelegate:(nullable id<KDataCollectorDebugDelegate>)debugDelegate;

- (NSString *)buildDateString;

// The post server to call for collection
@property (strong) NSString *server;

@end

NS_ASSUME_NONNULL_END
