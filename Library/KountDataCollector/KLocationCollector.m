//
//  KLocationCollector.m
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "KLocationCollector.h"
#import <QuartzCore/QuartzCore.h>

const int KLocationCollectorOldLocationLimit = 86400; // One Day

@interface KLocationCollector () <CLLocationManagerDelegate>
//KMS-9
@property CFTimeInterval startTime;
@property CFTimeInterval elapsedTime;
@property (strong) CLLocationManager *locationManager;
@property KLocationCollectorConfig config;
@property int timeoutInMS;
@property (strong) NSTimer *timeoutTimer;
@end

@implementation KLocationCollector 

- (NSString *)name 
{
    return @"Location Collector";
}

- (NSString *)internalName 
{
    return KDataCollectorInternalNameLocation;
}

- (id)initWithConfig:(KLocationCollectorConfig)config withTimeoutInMS:(int)timeoutInMS
{
    self = [super init];
    if (self) {
        self.config = config;
        self.timeoutInMS = timeoutInMS;
    }
    return self;
}

#pragma mark Location Manager Methods

// Used for mocking
- (NSString *)locationManagerClassName
{
    return @"CLLocationManager";
}

// Create a class from the class name string
- (CLLocationManager *)createLocationManager
{ 
    return (CLLocationManager *)[[NSClassFromString([self locationManagerClassName]) alloc] init];
}

#pragma mark Data Collection

- (void)timeout:(id)sender
{
    [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyTimeout];
}

- (void)collect
{
    // The asynchronous location collection needs to start on the main thread
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:(self.timeoutInMS / 1000.0) target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
        [self collectLocation];
    });
}

- (void)collectLocation 
{
    //KIOS-9 :Enhance Timing Metrics
    _startTime = CACurrentMediaTime();
    // Check for permissions
    //DMD-691
    CLAuthorizationStatus auth;
    if (@available(iOS 14.0, *)) {
        CLLocationManager *manager = [[NSClassFromString([self locationManagerClassName]) alloc] init];
        auth = manager.authorizationStatus;
    }
    else {
        auth = [NSClassFromString([self locationManagerClassName]) authorizationStatus];
    }
    
    KCOLLECTOR_DEBUG_MESSAGE(@"Initial Auth Status = %ld", (long)auth);
    
    if (kCLAuthorizationStatusDenied == auth) {
        KCOLLECTOR_DEBUG_MESSAGE(@"User Denied Permission");
        [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyPermissionDenied];
        return;
    }
    
    if(kCLAuthorizationStatusRestricted == auth) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Location Service Unavailable");
        [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyServiceUnavailable];
        return;
    }
    
    if (auth == kCLAuthorizationStatusNotDetermined && self.config == KLocationCollectorConfigPassive) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Passively Skipping Location");
        [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyPassivelySkipped];
        return;
    }
    
    self.locationManager = [self createLocationManager];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;

    if (auth == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
            return;
        }
    }
    [self startGettingLocation];
}

- (void)startGettingLocation 
{
    KCOLLECTOR_DEBUG_MESSAGE(@"Start Getting Location");
    [self.locationManager startUpdatingLocation];
    // Send in the cached location if any
    [self storeLocation:self.locationManager.location];
}

- (void)stopLocationOnSoftError:(NSString *)softError
{
    [self.timeoutTimer invalidate];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    [self addSoftError:softError];
    
    //KIOS-20: ReverseGeoData from iOS Device SDK
    if (softError == KDataCollectorPostSoftErrorKeyAddressFieldsUnavailable) {
        [self callCompletionBlock:YES error:nil];
    }
    else {
        [self callCompletionBlock:NO error:nil];
    }
}

- (void)storeLocation:(CLLocation *)location 
{
    if (nil != location) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Accepting Location (%f, %f) Age: %ld Seconds", location.coordinate.latitude, location.coordinate.longitude, (long)(-1 * [location.timestamp timeIntervalSinceNow]));
        // The timestamp has been within the hour, so let's use it
        if (fabs([location.timestamp timeIntervalSinceNow]) < KLocationCollectorOldLocationLimit) {
            [self.timeoutTimer invalidate];
            
            //KMS-2 Issue fix
           // self.locationManager.delegate = nil;
            [self.locationManager stopUpdatingLocation];
            self.locationManager = nil;
            
            // Value less than zero indicates not valid information
            if(location.horizontalAccuracy < 0) {
                KCOLLECTOR_DEBUG_MESSAGE(@"Bad Location Information");
                [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyUnexpected];
            }
            else {
                //KIOS-9 :Enhance Timing Metrics
                _elapsedTime = CACurrentMediaTime() - _startTime;
                [self addDataPoint:[NSString stringWithFormat:@"%f",_elapsedTime*1000.0] forKey:KDataCollectorPostKeyLocationCollectorElapsedTime];
                
                [self addDataPoint:[NSString stringWithFormat:@"%g", location.coordinate.latitude] forKey:KDataCollectorPostKeyLocationLatitude];
                [self addDataPoint:[NSString stringWithFormat:@"%g", location.coordinate.longitude] forKey:KDataCollectorPostKeyLocationLongitude];
                [self addDataPoint:[NSString stringWithFormat:@"%lu", ((long)[location.timestamp timeIntervalSince1970])] forKey:KDataCollectorPostKeyLocationDate];
                
                //KIOS-20: ReverseGeoData from iOS Device SDK
                 [self getAddressFromLocation:location completion:^{
                    [self callCompletionBlock:YES error:nil];
                }];
            }
        } 
    }
} 

//KIOS-20: ReverseGeoData from iOS Device SDK
- (void)getAddressFromLocation:(CLLocation *)location completion:(void(^)(void))callback {
    CFTimeInterval startTimeForGettingLocation = CACurrentMediaTime();
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //TRIAGE-1817-Language-Fix
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [geocoder reverseGeocodeLocation:location preferredLocale:locale completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error) {
             [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyAddressNotCollected];
             return;
         }
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             [self getAddressFields:placemark];
                
             CFTimeInterval elapsedTimeForGettingLocation = CACurrentMediaTime() - startTimeForGettingLocation;
             [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForGettingLocation*1000.0] forKey:KDataCollectorPostKeyReverseGeocodeElapsedTime];

             if (placemark.name == nil || placemark.thoroughfare == nil || placemark.locality == nil || placemark.administrativeArea == nil || placemark.country == nil || placemark.postalCode == nil || placemark.ISOcountryCode == nil) {
                KCOLLECTOR_DEBUG_MESSAGE(@"Some adddress fields unavailable");
                [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyAddressFieldsUnavailable];
                return;
             }
             callback();
         }
     }];
}

//KIOS-20: ReverseGeoData from iOS Device SDK
- (void)getAddressFields:(CLPlacemark *)placemark {
     NSString *address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@",[placemark name],[placemark thoroughfare],[placemark locality],[placemark administrativeArea],[placemark country], [placemark postalCode], [placemark ISOcountryCode]];
      NSLog(@"Address from CLGeocoder : %@", address);
      NSString *organization = [placemark name];
      NSString *street = [placemark thoroughfare];
      NSString *city = [placemark locality];
      NSString *region = [placemark administrativeArea];
      NSString *country = [placemark country];
      NSString *postalCode = [placemark postalCode];
      NSString *ISO = [placemark ISOcountryCode];
                
      if(organization != nil) {
        [self addDataPoint:organization forKey:KDataCollectorPostKeyOrganization];
      }
      if(street != nil) {
          [self addDataPoint:street forKey:KDataCollectorPostKeyStreet];
      }
      if (city != nil) {
          [self addDataPoint:city forKey:KDataCollectorPostKeyCity];
      }
      if(region != nil) {
          [self addDataPoint:region forKey:KDataCollectorPostKeyState];
      }
      if(country != nil) {
          [self addDataPoint:country forKey:KDataCollectorPostKeyCountry];
      }
      if(postalCode != nil) {
          [self addDataPoint:postalCode forKey:KDataCollectorPostKeyPostalCode];
      }
      if(ISO != nil) {
          [self addDataPoint:ISO forKey:KDataCollectorPostKeyISO];
      }
}

#pragma mark Location Manager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations 
{
    CLLocation *location = [locations lastObject];
    KCOLLECTOR_DEBUG_MESSAGE(@"Location Update (%f, %f) Age: %ld Seconds", location.coordinate.latitude, location.coordinate.longitude, (long)(-1 * [location.timestamp timeIntervalSinceNow]));
    [self storeLocation:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    KCOLLECTOR_DEBUG_MESSAGE(@"System Error: %@", error.localizedDescription);
    [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyUnexpected];
}

//DMD-691
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self evaluteAuthorizationStatus:status];
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager API_AVAILABLE(ios(14)) {
    CLAuthorizationStatus status = manager.authorizationStatus;
    [self evaluteAuthorizationStatus:status];
}

- (void)evaluteAuthorizationStatus:(CLAuthorizationStatus)status {
    KCOLLECTOR_DEBUG_MESSAGE(@"Updated Auth Status = %ld", (long)status);
    // Location access denied by user
    if (kCLAuthorizationStatusRestricted == status || kCLAuthorizationStatusDenied == status) {
        KCOLLECTOR_DEBUG_MESSAGE(@"User Denied Permission");
        [self stopLocationOnSoftError:KDataCollectorPostSoftErrorKeyPermissionDenied];
    }
    else if (status != kCLAuthorizationStatusNotDetermined) {
        [self startGettingLocation];
    }
}

@end
