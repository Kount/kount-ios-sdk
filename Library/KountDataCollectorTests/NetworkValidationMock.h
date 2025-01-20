//
//  NetworkValidationMock.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#ifndef NetworkValidationMock_h
#define NetworkValidationMock_h

#import <SystemConfiguration/SystemConfiguration.h>
#import "NetworkValidation.h"

@interface NetworkValidationMock : NetworkValidation

+ (void)reset;
+ (void)setMockNetworkGetFailure:(BOOL)enable;
+ (void)setMockNetworkFlags:(SCNetworkReachabilityFlags)flags;

@end

#endif /* NetworkValidationMock_h */
