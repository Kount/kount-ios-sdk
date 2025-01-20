//
//  DeviceDataPayload.h
//  KountDataCollector
//
//  Created by Vamsi Krishna on 26/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDataPayload : NSObject
- (NSMutableDictionary *)transformingDeviceData:(NSDictionary *)dataFromDeviceSDK;
@end

NS_ASSUME_NONNULL_END
