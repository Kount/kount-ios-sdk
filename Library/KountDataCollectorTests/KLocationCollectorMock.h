//
//  KLocationCollectorMock.h
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#ifndef KLocationCollectorMock_h
#define KLocationCollectorMock_h

#import <CoreLocation/CoreLocation.h>
#import "KLocationCollector.h"

#pragma mark - Mock

@interface KLocationCollectorMock : KLocationCollector

+ (void)setMockDefaultAuthorizationStatus:(CLAuthorizationStatus)status;
+ (void)setMockLocationEnabled:(BOOL)enabled;
+ (void)setMockRequestAuthorization:(BOOL)enabled;
+ (void)setMockRequestAuthorizationReturnStatus:(CLAuthorizationStatus)status;
+ (void)setMockError:(BOOL)enabled;
+ (void)setMockBadAccuracy:(BOOL)enabled;
+ (void)setMockOverrideLocationClassName:(BOOL)enabled;
+ (void)resetMocks; 

@property KLocationCollectorConfig config;
@property BOOL overrideLocationManager;
@property CLAuthorizationStatus authorizationStatus;
- (NSString *)locationManagerClassName;

@end

#endif /* KLocationCollectorMock_h */
