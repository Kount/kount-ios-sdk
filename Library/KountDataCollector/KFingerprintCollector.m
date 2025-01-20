//
//  KFingerprintCollector.m
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import <arpa/inet.h>
#import <net/ethernet.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <netdb.h>
#import <sys/ioctl.h>
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/types.h>
#import "KCollectorTaskBase.h"
#import "KFingerprintCollector.h"
#import "KDictionary.h"
#import "KString.h"
#import <QuartzCore/QuartzCore.h>

@implementation KFingerprintCollector
- (NSString *)name
{
    return @"Fingerprint Collector";
}

- (NSString *)internalName 
{
    return KDataCollectorInternalNameFingerprint;
}

#pragma mark Data Collection

- (void)collect 
{
    //KIOS-9 :Enhance Timing Metrics
    CFTimeInterval startTimeForFingerprintCollector = CACurrentMediaTime();
    
    NSMutableDictionary *newCookies = [NSMutableDictionary dictionary];
    NSString *prevUIDCookie = nil;
    
    //KIOS-9 :Enhance Timing Metrics
    CFTimeInterval startTimeForOldDeviceCookie = CACurrentMediaTime();
    NSDictionary *oldCookies = [self readCookies];
    CFTimeInterval elapsedTimeForOldDeviceCookie = CACurrentMediaTime() - startTimeForOldDeviceCookie;

    if (oldCookies) {
        [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForOldDeviceCookie*1000.0] forKey: KDataCollectorPostKeyOldDeviceCookieElapsedTime];
        NSString *prevCookiesJson = [KDictionary jsonStringWithDict:oldCookies];
        [self addDataPoint:prevCookiesJson forKey:KDataCollectorPostKeyOldDeviceCookie];
        prevUIDCookie = [oldCookies objectForKey:KDataCollectorPostKeyCookieUID];
    }
    //KIOS-9 :Enhance Timing Metrics
    CFTimeInterval startTimeForDeviceCookie = CACurrentMediaTime();
    if (prevUIDCookie != nil) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Using previous UID: %@", prevUIDCookie);
        [newCookies setObject:prevUIDCookie forKey:KDataCollectorPostKeyCookieUID];
    }
    else {
        // Rollin' our own unique ID
        KCOLLECTOR_DEBUG_MESSAGE(@"Creating new UID: %@", prevUIDCookie);
        NSString *deviceName = [[UIDevice currentDevice] name];
        NSString *epoch = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        NSString *uidCookie = [KString sha256HashWithString:[[KDataCollectorPostKeyCookieUID stringByAppendingString:epoch] stringByAppendingString:deviceName]];
        [newCookies setObject:uidCookie forKey:KDataCollectorPostKeyCookieUID];
    }
    // Vendor ID
    NSString *vendorID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (vendorID) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Obtained vendor identifier: %@", vendorID);
        NSString *vidCookie = [KString sha256HashWithString:[KDataCollectorPostKeyVendorUID stringByAppendingString:vendorID]];
        [newCookies setObject:vidCookie forKey:KDataCollectorPostKeyVendorUID];
    } 
    else {
        KCOLLECTOR_DEBUG_MESSAGE(@"Couldn't obtain vendor identifier");
    }
    CFTimeInterval elapsedTimeForDeviceCookie = CACurrentMediaTime() - startTimeForDeviceCookie;
    [self addDataPoint:[KDictionary jsonStringWithDict:newCookies] forKey:KDataCollectorPostKeyDeviceCookie];
    
    if (![self writeCookies:newCookies]) {
        [self addSoftError:KDataCollectorPostSoftErrorKeyUnexpected];
        [self callCompletionBlock:NO error:nil];
        return;
    }
   
    //KIOS-9 :Enhance Timing Metrics
    CFTimeInterval elapsedTimeForFingerprintCollector = CACurrentMediaTime() - startTimeForFingerprintCollector;
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForDeviceCookie*1000.0] forKey:KDataCollectorPostKeyDeviceCookieElapsedTime];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForFingerprintCollector*1000.0] forKey:KDataCollectorPostKeyFingerprintCollectorElapsedTime];
       
#ifdef DEBUG
    [self debugOutputNewCookies:newCookies oldCookies:oldCookies];
#endif
    
    [self callCompletionBlock:YES error:nil];

}

#pragma mark Helper Methods

#ifdef DEBUG
- (void)debugOutputNewCookies:(NSDictionary *)newCookies oldCookies:(NSDictionary *)oldCookies 
{
    for (NSString *key in [newCookies allKeys]) {
        NSString *newCookie = [newCookies objectForKey:key];
        NSString *oldCookie = [oldCookies objectForKey:key];
        bool match = [oldCookie isEqualToString:newCookie];
        KCOLLECTOR_DEBUG_MESSAGE(@"%@ cookie %@ old cookie", [key lowercaseString], (match ? @"matched": @"did NOT match"));
    }
}
#endif

- (NSString *)cookieFilePath 
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //Task Id: KMS-1
    NSError *error;
    //Check if file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
        //Will Create file if doesn't exist
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    //KIOS-23
    NSURL *URL = [NSURL fileURLWithPath:documentPath];
    NSLog(@"URL:%@", URL);
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    NSLog(@"Result:%d", success);
   
    return [documentPath stringByAppendingPathComponent:@"DCCollector.plist"];
}

- (BOOL)writeCookies:(NSDictionary *)dict
{
    BOOL saved = [dict writeToFile:[self cookieFilePath] atomically:YES];
    
#ifdef DEBUG
    NSString *filePath = [self cookieFilePath];
    if (!saved) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Couldn't write cookie file (%@)", filePath);
    } 
    else {
        KCOLLECTOR_DEBUG_MESSAGE(@"Cookie file written (%@)", filePath);
    }
#endif
    
    return saved;
}

- (NSDictionary*)readCookies 
{
    NSString *filePath = [self cookieFilePath];
    NSDictionary *cookieDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
#ifdef DEBUG
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Cookie file doesn't exist (%@)", filePath);
    }
    else if (nil == cookieDict) {
        KCOLLECTOR_DEBUG_MESSAGE(@"Couldn't read cookie file (%@)", filePath);
    } 
    else {
        KCOLLECTOR_DEBUG_MESSAGE(@"Cookie file read (%@)", filePath);
    }
#endif
    
    return cookieDict;
}

@end
