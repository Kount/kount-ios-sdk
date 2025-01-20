//
//  Common.h
//  TestApp
//
//  Created by Keith Feldman on 2/1/16.
//  CCopyright © 2016 Kount Inc. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define kSettingsMerchantIDKey      @"MerchantID"
#define kSettingsMerchantIDDefault  @"999999"
#define kSettingsServerKey          @"Server"
#define kSettingsServer             @"https://tst.kaptcha.com/"
#define kSettingsTimeoutKey         @"Timeout"
#define kSettingsTimeoutDefault     @10000

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* Common_h */
