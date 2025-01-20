//
//  KLocationCollectorMock.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLocationCollectorMock.h"

#pragma mark Mocked CLLocationManager

static CLAuthorizationStatus _mockDefaultAuthorizationStatus = kCLAuthorizationStatusNotDetermined;
static BOOL _mockLocationEnabled = NO;
static BOOL _mockRequestAuthorization = NO;
static CLAuthorizationStatus _mockRequestAuthorizationReturnStatus = kCLAuthorizationStatusDenied;
static BOOL _mockError = NO;
static BOOL _mockBadAccuracy = NO;
static BOOL _mockOverrideClassName = YES;

@interface KTestCLLocationManager : CLLocationManager
@property(assign, nonatomic, nullable) id<CLLocationManagerDelegate> mockDelegate;
@property(assign, nonatomic) CLAuthorizationStatus mockAuthorizationStatus;
- (CLAuthorizationStatus)authorizationStatus;
@end

@implementation KTestCLLocationManager

- (CLAuthorizationStatus)authorizationStatus
{
    return _mockDefaultAuthorizationStatus;
}

+ (BOOL)locationServicesEnabled
{
    return _mockLocationEnabled;
}

- (void)startUpdatingLocation
{
    if (_mockError) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.mockDelegate locationManager:self didFailWithError:[NSError errorWithDomain:@"TESTERROR" code:10 userInfo:nil]];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (_mockBadAccuracy) {
            CLLocation *loc = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(-10, 20) altitude:0 horizontalAccuracy:-1 verticalAccuracy:-1 timestamp:[NSDate date]];
            [self.mockDelegate locationManager:self didUpdateLocations:@[loc]];
        }
        else {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:-10 longitude:20];
            [self.mockDelegate locationManager:self didUpdateLocations:@[loc]];
        }
    });
}

- (void)requestWhenInUseAuthorization
{
    _mockDefaultAuthorizationStatus = _mockRequestAuthorizationReturnStatus;
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.mockDelegate locationManager:self didChangeAuthorizationStatus:_mockDefaultAuthorizationStatus];
    });
}

- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate
{
    self.mockDelegate = delegate;
}

@end

#pragma mark Expose methods from collector

@interface KLocationCollector ()

- (NSString *)locationManagerClassName;

@end

#pragma mark - Overridden class for testing

@implementation KLocationCollectorMock

- (id)initWithConfig:(KLocationCollectorConfig)config 
{
    self = [super initWithConfig:config withTimeoutInMS:1000];
    if (self) {
        self.config = config;
    }
    return self;
}

- (NSString *)locationManagerClassName
{
    if (!_mockOverrideClassName) {
        return [super locationManagerClassName];
    }
    return @"KTestCLLocationManager";
}

+ (void)resetMocks 
{
    _mockDefaultAuthorizationStatus = kCLAuthorizationStatusNotDetermined;
    _mockLocationEnabled = NO;
    _mockRequestAuthorization = NO;
    _mockRequestAuthorizationReturnStatus = kCLAuthorizationStatusDenied;
    _mockError = NO;
    _mockBadAccuracy = NO;
    _mockOverrideClassName = YES;
}

+ (void)setMockDefaultAuthorizationStatus:(CLAuthorizationStatus)status
{
    _mockDefaultAuthorizationStatus = status;
}

+ (void)setMockLocationEnabled:(BOOL)enabled
{
    _mockLocationEnabled = enabled;
}

+ (void)setMockRequestAuthorization:(BOOL)enabled
{
    _mockRequestAuthorization = enabled;
}

+ (void)setMockRequestAuthorizationReturnStatus:(CLAuthorizationStatus)status
{
    _mockRequestAuthorizationReturnStatus = status;
}

+ (void)setMockError:(BOOL)enabled 
{
    _mockError = enabled;
}

+ (void)setMockBadAccuracy:(BOOL)enabled
{
    _mockBadAccuracy = enabled;
    
}

+ (void)setMockOverrideLocationClassName:(BOOL)enabled
{
    _mockOverrideClassName = enabled;
}

@end

