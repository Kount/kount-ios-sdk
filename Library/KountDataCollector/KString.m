//
//  KString.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/16/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "KString.h"

@implementation KString

+ (NSString *)sha256HashWithString:(NSString *)inputString
{
    const char* str = [inputString UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:(CC_SHA256_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@end
