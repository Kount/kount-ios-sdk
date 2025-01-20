//
//  NetworkValidation.h
//  KountDataCollector
//
//  Created by Felipe Plaza on 12-03-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import "KDataCollector_Internal.h"
#import <arpa/inet.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ErrorHandling.h"

@interface NetworkValidation : NSObject

+ (BOOL)validateNetwork:(NSString *)sessionID isDebug:(BOOL)isDebug completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate;
+ (void)setMockOverrideClassName:(BOOL)enable;
+ (void)reset;

@end
