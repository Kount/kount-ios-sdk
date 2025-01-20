//
//  KFingerprintCollectorMock.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFingerprintCollectorMock.h"

@implementation KTestFingerprintCollector

- (NSString *)cookieFilePath 
{
    if (self.mockCookieWriteFail) {
        return @"\0";
    }
    else return [super cookieFilePath];
}

@end

