//
//  NSDictionary.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/16/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import "KDictionary.h"

@implementation KDictionary

+ (NSString *)jsonStringWithDict:(NSDictionary *)dict
{
    NSError *error = nil;
    @try {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    @catch (NSException *exception) {
#ifdef DEBUG
        NSLog(@"Exception encountered while converting to JSON: %@", exception.name);
#endif
    }
#ifdef DEBUG
    NSLog(@"Error encountered while converting to JSON: %@", error.localizedDescription);
#endif
    return nil;
}

@end
