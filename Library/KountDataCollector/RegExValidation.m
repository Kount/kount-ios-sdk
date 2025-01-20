//
//  RegExValidation.m
//  KountDataCollector
//
//  Created by Felipe Plaza on 22-01-24.
//  Copyright © 2024 Kount Inc. All rights reserved.
//

#import "RegExValidation.h"
#import <Foundation/Foundation.h>
#import "KDataCollector_Internal.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <arpa/inet.h>
#import "DebugMessages.h"
#import "CompletionBlock.h"
#import "ErrorHandling.h"

@implementation RegExValidation
//MARK: - Constants

// Regular Expressions for Validation
NSString *const KDataCollectorRegExURL = @"^https://[\\w-]+(\\.[\\w-]+)+(/[^?]*)?$";
NSString *const KDataCollectorRegExMerchantID = @"(^\\d{6}$)|(^\\d{15}$)";
NSString *const KDataCollectorRegExSessionID = @"^[A-Za-z0-9-_]{1,36}$";

//MARK: - Functions

/// Finds and returns a bool if the RegEx satisfies the condition
+ (BOOL)matchRegEx:(NSString*)testString pattern:(NSString*)pattern {
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error || testString == nil) {
#if DEBUG
        NSLog(@"Debug: Error creating regex: %@", error.localizedDescription);
#endif
        
        return NO;
    }
    
    NSUInteger matches = [regex numberOfMatchesInString:testString options:0 range:NSMakeRange(0, [testString length])];
    
    return  matches > 0;
}

#pragma mark Validation

+ (BOOL)validMerchantID:(NSString *)sessionID isDebug:(BOOL)isDebug merchantID:(NSString *)merchantID completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate {
    if (![RegExValidation matchRegEx:merchantID pattern:KDataCollectorRegExMerchantID]) {
        [ErrorHandling failWithErrorMessage:@"Merchant ID formatted incorrectly." code:KDataCollectorErrorCodeBadParameter isDebug:isDebug debugDelegate:debugDelegate sessionID:sessionID completionBlock:completionBlock];
        return NO;
    }
    return YES;
}

+ (BOOL)validURL:(NSString *)sessionID isDebug:(BOOL)isDebug server:(NSString *)server completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate {
    if (![RegExValidation matchRegEx:server pattern:KDataCollectorRegExURL]) {
        [ErrorHandling failWithErrorMessage:@"URL formatted incorrectly." code:KDataCollectorErrorCodeBadParameter isDebug:isDebug debugDelegate:debugDelegate sessionID:sessionID completionBlock:completionBlock];
        return NO;
    }
    return YES;
}

+ (BOOL)validSessionID:(NSString *)sessionID isDebug:(BOOL)isDebug completion:(KDataCollectorCompletionBlock)completionBlock debugDelegate:(id)debugDelegate {
    if (![RegExValidation matchRegEx:sessionID pattern:KDataCollectorRegExSessionID]) {
        [ErrorHandling failWithErrorMessage:@"Session ID formatted incorrectly." code:KDataCollectorErrorCodeBadParameter isDebug:isDebug debugDelegate:debugDelegate sessionID:sessionID completionBlock:completionBlock];
        return NO;
    }
    return YES;
}

@end

