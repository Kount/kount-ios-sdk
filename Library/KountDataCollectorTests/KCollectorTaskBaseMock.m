//
//  KCollectorTaskBaseMock.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCollectorTaskBaseMock.h"

static BOOL _mockOverrideCollect = NO;

@implementation KCollectorTaskBaseMock

- (void)collect 
{
    if (_mockOverrideCollect) {
        [self callCompletionBlock:YES error:nil];
    }
    else {
        [super collect];
    }
}

- (NSString *)internalName 
{
    return @"INTERNAL_NAME";
}

- (NSString *)name 
{
    return @"NAME";
}

+ (void)resetMocks 
{
    _mockOverrideCollect = NO;
}

+ (void)setMockOverrideCollect:(BOOL)enable
{
    _mockOverrideCollect = enable;
}


@end
