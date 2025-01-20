//
//  ErrorHandling.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorHandling.h"
#import "CompletionBlock.h"

@implementation ErrorHandling


+ (void)failWithErrorMessage:(NSString *)message code:(NSInteger)errorCode isDebug:(BOOL)isDebug debugDelegate:(id)debugDelegate sessionID:(NSString *)sessionID completionBlock:(__strong KDataCollectorCompletionBlock)completionBlock {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
    NSError *error = [NSError errorWithDomain:KDataCollectorErrorDomain code:errorCode userInfo:userInfo];
    [CompletionBlock callCompletionBlock:completionBlock sessionID:sessionID isDebug:isDebug success:NO error:error debugDelegate:debugDelegate];
}

@end
