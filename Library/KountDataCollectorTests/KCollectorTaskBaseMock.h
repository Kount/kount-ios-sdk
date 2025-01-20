//
//  KCollectorTaskBaseMock.h
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#ifndef KCollectorTaskBaseMock_h
#define KCollectorTaskBaseMock_h

#import "KCollectorTaskBase.h"

@interface KCollectorTaskBase ()

// Expose methods and properties for testing
- (void)addDataPoint:(NSObject *)object forKey:(NSString *)key;
@property (strong) NSMutableDictionary *data;
@property (strong) NSMutableDictionary *softErrors;
@property (copy) KCollectorTaskBaseCompletionBlock completionBlock;

@end

#pragma mark - Mock

@interface KCollectorTaskBaseMock : KCollectorTaskBase

+ (void)resetMocks;
+ (void)setMockOverrideCollect:(BOOL)enable;

@end

#endif /* KCollectorTaskBaseMock_h */
