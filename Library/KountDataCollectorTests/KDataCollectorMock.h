//
//  KDataCollectorMock.h
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#ifndef KDataCollectorMock_h
#define KDataCollectorMock_h

#import <SystemConfiguration/SystemConfiguration.h>
#import "KDataCollector_Internal.h"
#import "KLocationCollectorMock.h"

#pragma mark - Mock

@interface KDataCollectorMock : KDataCollector

+ (void)resetMocks;
+ (void)setMockDidNotSend:(BOOL)enabled;
- (void)asynchronousSend:(NSMutableURLRequest *)mobileRequest completion:(nullable void (^)(BOOL result, NSError* error))completionBlock;
- (KLocationCollector *)createLocationCollector;
@end

#endif /* KDataCollectorMock_h */
