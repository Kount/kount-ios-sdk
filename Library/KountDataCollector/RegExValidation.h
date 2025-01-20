//
//  RegExValidation.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 22-01-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataCollector_Internal.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface RegExValidation : NSObject

+ (BOOL)matchRegEx:(NSString*)testString pattern:(NSString*)pattern;
+ (BOOL)validMerchantID:(NSString *)sessionID isDebug:(BOOL)isDebug merchantID:(NSString *)merchantID completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate;
+ (BOOL)validURL:(NSString *)sessionID isDebug:(BOOL)isDebug server:(NSString *)server completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate;
+ (BOOL)validSessionID:(NSString *)sessionID isDebug:(BOOL)isDebug completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate;
@end
