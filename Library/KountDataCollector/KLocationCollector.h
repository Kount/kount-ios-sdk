//
//  KLocationCollector.h
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import "KCollectorTaskBase.h"

@interface KLocationCollector : KCollectorTaskBase

- (id)initWithConfig:(KLocationCollectorConfig)config withTimeoutInMS:(int)timeoutInMS;

@end
