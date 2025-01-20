//
//  CompletionBlock.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 11-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import "KDataCollector_Internal.h"

@interface CompletionBlock : NSObject

+ (void)callCompletionBlock:(KDataCollectorCompletionBlock)completionBlock sessionID:(NSString *)sessionID isDebug:(BOOL)isDebug success:(BOOL)success error:(NSError *)error debugDelegate:debugDelegate;

@end
