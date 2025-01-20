//
//  KDictionary.h
//  KountDataCollector
//
//  Created by Keith Feldman on 2/16/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// This is created as a inherited class instead of a category because of the way things link in a static library
// (otherwise it would require all clients to include "-ObjC" as a linker flag in their projects)
@interface KDictionary : NSDictionary

+ (NSString *)jsonStringWithDict:(NSDictionary *)dict;

@end
