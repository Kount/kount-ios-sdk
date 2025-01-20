//
//  KFingerprintCollectorMock.h
//  KountDataCollector
//
//  Created by Keith Feldman on 2/23/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#ifndef KFingerprintCollectorMock_h
#define KFingerprintCollectorMock_h

#import "KFingerprintCollector.h"

@interface KFingerprintCollector ()

- (NSString *)cookieFilePath;
- (BOOL)writeCookies:(NSDictionary *)dict;

@end

#pragma mark - Mock

@interface KTestFingerprintCollector : KFingerprintCollector

@property BOOL mockCookieWriteFail;

@end


#endif /* KFingerprintCollectorMock_h */
