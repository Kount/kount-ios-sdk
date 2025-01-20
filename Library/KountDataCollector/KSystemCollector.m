//
//  KSystemCollector.m
//  KountDataCollector
//
//  Created by Keith Feldman on 1/13/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import "KSystemCollector.h"
#import <sys/sysctl.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIKit.h>

const int KSystemCollectorMemoryDivisor = (1024 * 1024); 
const int KSystemCollectorDiskDivisor = (1024 * 1024 * 1024);
const int KSystemCollectorTimezoneDivisor = -60;
const int KSystemCollectorMilliseconds = 1000;

@implementation KSystemCollector

- (NSString *)name 
{
    return @"System Collector";
}

- (NSString *)internalName 
{
    return KDataCollectorInternalNameSystem;
}

#pragma mark Data Collection

- (void)collect 
{
    //KIOS-9 :Enhance Timing Metrics
    CFTimeInterval startTimeForSystemCollector = CACurrentMediaTime();
    
    CFTimeInterval startTimeForMachine = CACurrentMediaTime();
    NSString *machine = [self getMachineName];
    CFTimeInterval elapsedTimeForMachine = CACurrentMediaTime() - startTimeForMachine;
    
    CFTimeInterval startTimeForosVersion = CACurrentMediaTime();
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    CFTimeInterval elapsedTimeForosVersion = CACurrentMediaTime() - startTimeForosVersion;
    
    CFTimeInterval startTimeFortotalMemory = CACurrentMediaTime();
    NSUInteger totalMemory = (NSUInteger)([self getTotalMemory] / KSystemCollectorMemoryDivisor);
    CFTimeInterval elapsedTimeFortotalMemory = CACurrentMediaTime() - startTimeFortotalMemory;
    
    CFTimeInterval startTimeForlocalDateTimeEpoch = CACurrentMediaTime();
    NSString *localDateTimeEpoch = [self getLocalDateTimeEpoch];
    CFTimeInterval elapsedTimeForlocalDateTimeEpoch = CACurrentMediaTime() - startTimeForlocalDateTimeEpoch;
    
    CFTimeInterval startTimeFortimeZoneCurrent = CACurrentMediaTime();
    NSInteger timezoneCurrent = [self getTimezoneCurrent];
    CFTimeInterval elapsedTimeFortimeZoneCurrent = CACurrentMediaTime() - startTimeFortimeZoneCurrent;
    
    CFTimeInterval startTimeForoffsetAugust = CACurrentMediaTime();
    NSInteger offsetAugust = [self getTimezoneOffsetAugust];
    CFTimeInterval elapsedTimeForoffsetAugust = CACurrentMediaTime() - startTimeForoffsetAugust;
    
    CFTimeInterval startTimeForoffsetFebruary = CACurrentMediaTime();
    NSInteger offsetFebruary = [self getTimezoneOffsetFebruary];
    CFTimeInterval elapsedTimeForoffsetFebruary = CACurrentMediaTime() - startTimeForoffsetFebruary;
    
    CFTimeInterval startTimeForlangAndCountry = CACurrentMediaTime();
    NSString *langAndCountry = [self getLanguageAndCountry];
    CFTimeInterval elapsedTimeForlangAndCountry = CACurrentMediaTime() - startTimeForlangAndCountry;
    
    CFTimeInterval startTimeForscreenDimensions = CACurrentMediaTime();
    NSString *screenDimensions = [self getScreenDimensions];
    CFTimeInterval elapsedTimeForscreenDimensions = CACurrentMediaTime() - startTimeForscreenDimensions;
    
    CFTimeInterval elapsedTimeForSystemCollector = CACurrentMediaTime() - startTimeForSystemCollector;
    
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForSystemCollector*1000.0] forKey:KDataCollectorPostKeySystemCollectorElapsedTime];
    [self addDataPoint:screenDimensions forKey:KDataCollectorPostKeyScreenDimensions];
     [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForscreenDimensions*1000.0] forKey:KDataCollectorPostKeyScreenDimensionsElapsedTime];
    [self addDataPoint:langAndCountry forKey:KDataCollectorPostKeyLanguageAndCountry];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForlangAndCountry*1000.0] forKey:KDataCollectorPostKeyLanguageAndCountryElapsedTime];
    [self addDataPoint:localDateTimeEpoch forKey:KDataCollectorPostKeyLocalDateTimeEpoch];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForlocalDateTimeEpoch*1000.0] forKey:KDataCollectorPostKeyLocalDateTimeEpochElapsedTime];
    [self addDataPoint:[NSNumber numberWithInteger:timezoneCurrent] forKey:KDataCollectorPostKeyTimezoneCurrent];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeFortimeZoneCurrent*1000.0] forKey:KDataCollectorPostKeyTimezoneCurrentElapsedTime];
    [self addDataPoint:[NSNumber numberWithInteger:offsetAugust] forKey:KDataCollectorPostKeyTimezoneAugust];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForoffsetAugust*1000.0] forKey:KDataCollectorPostKeyTimezoneAugustElapsedTime];
    [self addDataPoint:[NSNumber numberWithInteger:offsetFebruary] forKey:KDataCollectorPostKeyTimezoneFebruary];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForoffsetFebruary*1000.0] forKey:KDataCollectorPostKeyTimezoneFebruaryElapsedTime];
    [self addDataPoint:osVersion forKey:KDataCollectorPostKeyOSVersion];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForosVersion*1000.0] forKey:KDataCollectorPostKeyOSVersionElapsedTime];
    [self addDataPoint:machine forKey:KDataCollectorPostKeyMobileModel];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeForMachine*1000.0] forKey:KDataCollectorPostKeyMobileModelElapsedTime];
    [self addDataPoint:[NSNumber numberWithUnsignedInteger:totalMemory] forKey:KDataCollectorPostKeyTotalMemory];
    [self addDataPoint:[NSString stringWithFormat:@"%f",elapsedTimeFortotalMemory*1000.0] forKey:KDataCollectorPostKeyTotalMemoryElapsedTime];

    KCOLLECTOR_DEBUG_MESSAGE(@"Local DateTime Epoch: %@", localDateTimeEpoch);
    KCOLLECTOR_DEBUG_MESSAGE(@"OS Version: %@", osVersion);
    KCOLLECTOR_DEBUG_MESSAGE(@"Model: %@", machine);
    KCOLLECTOR_DEBUG_MESSAGE(@"Total Memory: %ld", (unsigned long)totalMemory);
    KCOLLECTOR_DEBUG_MESSAGE(@"Timezone Current: %ld", (long)timezoneCurrent);
    KCOLLECTOR_DEBUG_MESSAGE(@"Timezone Offset August: %ld", (long)offsetAugust);
    KCOLLECTOR_DEBUG_MESSAGE(@"Timezone Offset February: %ld", (long)offsetFebruary);
    KCOLLECTOR_DEBUG_MESSAGE(@"Language and Country: %@", langAndCountry);
    KCOLLECTOR_DEBUG_MESSAGE(@"Screen Dimensions: %@", screenDimensions);
    KCOLLECTOR_DEBUG_MESSAGE(@"Total Memory Elapsed Time: %ld", (unsigned long)totalMemory);

    [self callCompletionBlock:YES error:nil];
}   

- (NSString *)getLocalDateTimeEpoch
{
    NSTimeInterval now = ([[NSDate date] timeIntervalSince1970] * KSystemCollectorMilliseconds);
    return [NSString stringWithFormat:@"%lu", ((long)now)];
}

- (NSInteger)getTimezoneCurrent
{
    NSInteger timezoneCurrent = [[NSTimeZone localTimeZone] secondsFromGMT] / KSystemCollectorTimezoneDivisor;
    return timezoneCurrent;
}

- (NSString *)getMachineName 
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

- (NSString *)getLanguageAndCountry
{
    //Future proofing encase preferredLangues starts returning language-region-country
    NSString *local = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([local length] > 2){
        return local;
    }
    return [NSString stringWithFormat:@"%@-%@",[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode], [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
}

- (NSString *)getScreenDimensions
{
    CGSize screenSize      = [[UIScreen mainScreen] bounds].size;
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSInteger widthOfScreen  = (int)(screenSize.width * scale);
    NSInteger heightOfScreen = (int)(screenSize.height * scale);
    return [NSString stringWithFormat:@"%ldx%ld", (long)heightOfScreen, (long)widthOfScreen];
}

- (NSInteger)getTimezoneOffsetAugust
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *compsAugust = [[NSDateComponents alloc] init];
    [compsAugust setYear:2007];
    [compsAugust setMonth:8];
    [compsAugust setDay:1];
    NSDate *dateAugust = [calendar dateFromComponents:compsAugust];
    NSInteger offsetAugust = [[NSTimeZone localTimeZone] secondsFromGMTForDate:dateAugust];
    // divided by -60 to get the difference in minutes from UTC
    return offsetAugust / KSystemCollectorTimezoneDivisor;
}

- (NSInteger)getTimezoneOffsetFebruary
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *compsFebruary = [[NSDateComponents alloc] init];
    [compsFebruary setYear:2007];
    [compsFebruary setMonth:2];
    [compsFebruary setDay:1];
    NSDate *dateFebruary = [calendar dateFromComponents:compsFebruary];
    NSInteger offsetFebruary = [[NSTimeZone localTimeZone] secondsFromGMTForDate:dateFebruary];
    // divided by -60 to get the difference in minutes from UTC
    return offsetFebruary / KSystemCollectorTimezoneDivisor;
}

- (int64_t)getTotalMemory 
{
    size_t size = sizeof(int64_t);
    int64_t results;
    int mib[2] = {CTL_HW, HW_MEMSIZE};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (int64_t)results;
}

@end
