//
//  NetworkValidation.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkValidation.h"

//For testing purposes
static BOOL _mockOverrideClassName = YES;

@implementation NetworkValidation

+ (BOOL)validateNetwork:(NSString *)sessionID isDebug:(BOOL)isDebug completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate {
    if (![self validNetwork:sessionID isDebug:isDebug completion:completionBlock debugDelegate:debugDelegate]) {
        return NO;
    }
    return YES;
}

+ (BOOL)getNetworkFlags:(SCNetworkReachabilityFlags *)flags {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    
    BOOL retrievedFlags = SCNetworkReachabilityGetFlags(reachability, &(*flags));
    CFRelease(reachability);
    return retrievedFlags;
}

+ (BOOL)validNetwork:(NSString *)sessionID isDebug:(BOOL)isDebug completion:(__strong KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate {
    SCNetworkReachabilityFlags flags;
    BOOL successfullyRetrievedFlags;
    NSLog(@"%@", NSClassFromString([self regExClassName]));
    successfullyRetrievedFlags = [NSClassFromString([self regExClassName]) getNetworkFlags:&flags];
    
    if (successfullyRetrievedFlags) {
        BOOL networkAvailable = NO;
        BOOL reachable = flags & kSCNetworkFlagsReachable;
        BOOL connectionRequired = flags & kSCNetworkFlagsConnectionRequired;
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            networkAvailable = YES;
        }
        else if (reachable && !connectionRequired) {
            networkAvailable = YES;
        }
        if (networkAvailable) {
            return YES;
        }
    }
    
    [ErrorHandling failWithErrorMessage:@"Network not available." code:KDataCollectorErrorCodeNoNetwork isDebug:isDebug debugDelegate:debugDelegate sessionID:sessionID completionBlock:completionBlock];
    return NO;
}

//MARK: - This part is only for testing purposes
+ (void)reset {
    _mockOverrideClassName = YES;
}

+ (NSString *)regExClassName {
    if (_mockOverrideClassName) {
        return @"NetworkValidation";
    }
    return @"NetworkValidationMock";
}

+ (void)setMockOverrideClassName:(BOOL)enable {
    _mockOverrideClassName = enable;
}

@end
