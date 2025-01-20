//
//  KDataCollectorMock.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataCollectorMock.h"

static BOOL _mockDidNotSend = NO;

@implementation KDataCollectorMock

- (KLocationCollector *)createLocationCollector
{
    return [[KLocationCollectorMock alloc] initWithConfig:self.locationCollectorConfig withTimeoutInMS: 1000];
}

- (void)asynchronousSend:(NSMutableURLRequest *)mobileRequest completion:(nullable void (^)(BOOL result, NSError* error))completionBlock{
    if (_mockDidNotSend) {
        completionBlock(NO, [self returnError]);
    }
    else {
        completionBlock(YES, nil);
    }
}

- returnError{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Test Send Error"};
    return [NSError errorWithDomain:@"TESTDOMAIN" code:13 userInfo:userInfo];
}

+ (void)resetMocks 
{
    _mockDidNotSend = NO;
}

+ (void)setMockDidNotSend:(BOOL)enabled
{
    _mockDidNotSend = enabled;
}

@end

