//
//  DebugMessages.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 08-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DebugMessages.h"
#import "KDataCollector_Internal.h"

@implementation DebugMessages

+ (void)debugMessage:(NSString *)string isDebug:(BOOL)debug debugDelegate:(id<KDataCollectorDebugDelegate>)debugDelegate {
    if (debug) {
        NSLog(@"%@", string);
    }
    if (debugDelegate && [debugDelegate respondsToSelector:@selector(collectorDebugMessage:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [debugDelegate collectorDebugMessage:string];
        });
    }
}

@end


