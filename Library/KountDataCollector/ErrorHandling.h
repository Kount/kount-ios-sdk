//
//  ErrorHandling.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import "KDataCollector_Internal.h"

@interface ErrorHandling : NSObject

+ (void)failWithErrorMessage:(NSString *)message code:(NSInteger)errorCode isDebug:(BOOL)isDebug debugDelegate:(id)debugDelegate sessionID:(NSString *)sessionID completionBlock:(KDataCollectorCompletionBlock)completionBlock;

@end
