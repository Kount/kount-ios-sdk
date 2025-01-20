//
//  DeviceDataPayload.m
//  KountDataCollector
//
//  Created by Vamsi Krishna on 26/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import "DeviceDataPayload.h"
#import "PostPayloadKeys.h"


@implementation DeviceDataPayload

// MARK: TypeCasting Device Data Method

//Typecasting Device data to required types and format.
- (NSMutableDictionary *)transformingDeviceData:(NSDictionary *)dataFromDeviceSDK {
    NSMutableDictionary *deviceDataDict = [[NSMutableDictionary alloc] init];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"e"] != nil) ? [NSNumber numberWithLongLong:[[dataFromDeviceSDK objectForKey:@"e"] integerValue]] : nil forKey:TotalClientTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"e_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"e_et"] doubleValue]] : nil forKey:TotalClientTimeElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"lat"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"lat"] doubleValue]] : nil forKey:Latitude];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"lon"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"lon"] doubleValue]] : nil forKey:Longitude];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ltm"] != nil) ? [NSNumber numberWithLongLong:[[dataFromDeviceSDK objectForKey:@"ltm"] integerValue]] : nil forKey:LastModifiedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"location_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"location_et"] doubleValue]] : nil forKey:LocationCollectorElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"city"] != nil) ? [dataFromDeviceSDK objectForKey:@"city"] : nil forKey:City];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"region"] != nil) ? [dataFromDeviceSDK objectForKey:@"region"] : nil forKey:Region];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"country"] != nil) ? [dataFromDeviceSDK objectForKey:@"country"] : nil forKey:Country];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"iso_country_code"] != nil) ? [dataFromDeviceSDK objectForKey:@"iso_country_code"] : nil forKey:ISOCountryCode];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"postal_code"] != nil) ? [NSNumber numberWithLongLong:[[dataFromDeviceSDK objectForKey:@"postal_code"] integerValue]] : nil forKey:PostalCode];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"org_name"] != nil) ? [dataFromDeviceSDK objectForKey:@"org_name"] : nil forKey:OrganisationName];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"street"] != nil) ? [dataFromDeviceSDK objectForKey:@"street"] : nil forKey:Street];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"geocoding_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"geocoding_et"] doubleValue]] : nil forKey:GeocodingElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"st"] != nil) ? [dataFromDeviceSDK objectForKey:@"st"] : nil forKey:SDKType];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"sv"] != nil) ? [dataFromDeviceSDK objectForKey:@"sv"] : nil forKey:SDKVersion];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"mdl"] != nil) ? [dataFromDeviceSDK objectForKey:@"mdl"] : nil forKey:Model];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"mdl_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"mdl_et"] doubleValue]] : nil forKey:ModelElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"os"] != nil) ? [dataFromDeviceSDK objectForKey:@"os"] : nil forKey:OSVersion];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"os_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"os_et"] doubleValue]] : nil forKey:OSVersionElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ddk"] != nil) ? [dataFromDeviceSDK objectForKey:@"ddk"] : nil forKey:TotalDisk];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ddk_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"ddk_et"] doubleValue]] : nil forKey:TotalDiskElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"dmm"] != nil) ? [dataFromDeviceSDK objectForKey:@"dmm"] : nil forKey:TotalMemory];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"dmm_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"dmm_et"] doubleValue]] : nil forKey:TotalMemoryElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ln"] != nil) ? [dataFromDeviceSDK objectForKey:@"ln"] : nil forKey:Language];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ln_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"ln_et"] doubleValue]] : nil forKey:LanguageElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"t0"] != nil) ? [dataFromDeviceSDK objectForKey:@"t0"] : nil forKey:TimezoneNow];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"t0_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"t0_et"] doubleValue]] : nil forKey:TimezoneNowElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"tf"] != nil) ? [dataFromDeviceSDK objectForKey:@"tf"] : nil forKey:TimezoneFebruary];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"tf_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"tf_et"] doubleValue]] : nil forKey:TimezoneFebruaryElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ta"] != nil) ? [dataFromDeviceSDK objectForKey:@"ta"] : nil forKey:TimezoneAugust];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"ta_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"ta_et"] doubleValue]] : nil forKey:TimezoneAugustElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"sa"] != nil) ? [dataFromDeviceSDK objectForKey:@"sa"] : nil forKey:ScreenAvailable];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"sa_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"sa_et"] doubleValue]] : nil forKey:ScreenAvailableElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"system_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"system_et"] doubleValue]] : nil forKey:SystemCollectorElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"dc"] != nil) ? [dataFromDeviceSDK objectForKey:@"dc"] : nil forKey:DeviceCookie];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"dc_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"dc_et"] doubleValue]] : nil forKey:DeviceCookieElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"odc"] != nil) ? [dataFromDeviceSDK objectForKey:@"odc"] : nil forKey:OldDeviceCookie];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"odc_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"odc_et"] doubleValue]] : nil forKey:OldDeviceCookieElapsedTime];
    [deviceDataDict setValue:([dataFromDeviceSDK objectForKey:@"fingerprint_et"] != nil) ? [NSNumber numberWithDouble:[[dataFromDeviceSDK objectForKey:@"fingerprint_et"] doubleValue]] : nil forKey:FingerprintCollectorElapsedTime];
    return deviceDataDict;
}

@end
