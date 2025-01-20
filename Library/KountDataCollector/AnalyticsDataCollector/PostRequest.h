//
//  PostRequest.h
//  KountDataCollector
//
//  Created by Vamsi Krishna on 27/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDataCollector.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostRequest : NSObject
- (void)postingDataToServer:(NSData *)postData postURL:(NSString *)postEnvironmentURL;
@end

NS_ASSUME_NONNULL_END
