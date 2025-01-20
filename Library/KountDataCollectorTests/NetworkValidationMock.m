//
//  NetworkValidationMock.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkValidationMock.h"

static BOOL _mockNetworkGetFailure = NO;
static SCNetworkReachabilityFlags _mockNetworkFlags = kSCNetworkReachabilityFlagsReachable;

@implementation NetworkValidationMock

+ (void)reset {
    _mockNetworkGetFailure = NO;
    _mockNetworkFlags = kSCNetworkReachabilityFlagsReachable;
}

+ (void)setMockNetworkGetFailure:(BOOL)enable {
    _mockNetworkGetFailure = enable;
}

+ (void)setMockNetworkFlags:(SCNetworkReachabilityFlags)flags {
    _mockNetworkFlags = flags;
}

+ (BOOL)getNetworkFlags:(SCNetworkReachabilityFlags *)flags {
    if (_mockNetworkGetFailure) {
        *flags = 0;
        return NO;
    }
    *flags = _mockNetworkFlags;
    return YES;
}

@end
