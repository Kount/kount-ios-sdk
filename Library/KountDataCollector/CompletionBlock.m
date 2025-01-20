//
//  CompletionBlock.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 11-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompletionBlock.h"
#import "KDataCollector_Internal.h"
#import "DebugMessages.h"

@implementation CompletionBlock

// Helper method for calling the completion block so that information can be sent to the console as well as executing the completion block on the main thread
+ (void)callCompletionBlock:(KDataCollectorCompletionBlock)completionBlock sessionID:(NSString *)sessionID isDebug:(BOOL)isDebug success:(BOOL)success error:(NSError *)error debugDelegate:debugDelegate {
    if (success) {
        [DebugMessages debugMessage:[NSString stringWithFormat:@"(%@) Collector completed successfully.", sessionID] isDebug:isDebug debugDelegate:debugDelegate];
    } else {
        if (error) {
            [DebugMessages debugMessage:[NSString stringWithFormat:@"(%@) Collector failed w/ error (%ld): %@.", sessionID, (long)error.code, error.localizedDescription] isDebug:isDebug debugDelegate:debugDelegate];
        } else {
            [DebugMessages debugMessage:[NSString stringWithFormat:@"(%@) Collector failed.", sessionID] isDebug:isDebug debugDelegate:debugDelegate];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completionBlock) {
            completionBlock(sessionID, success, error);
        } else {
#ifdef DEBUG
            [DebugMessages debugMessage:[NSString stringWithFormat:@"(%@) !! Completion block handler no longer exists.", sessionID] isDebug:isDebug debugDelegate:debugDelegate];
#endif
        }
    });
}

@end
