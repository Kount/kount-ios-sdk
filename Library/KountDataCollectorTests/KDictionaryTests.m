//
//  KDictionaryTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/18/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KDictionary.h"
#import "KDataCollectorMock.h"

@interface KDictionaryTests : XCTestCase

@end

@implementation KDictionaryTests

- (void)testNormal
{
    NSDictionary *testDict = @{@"key": @"value"};
    NSString *jsonString = [KDictionary jsonStringWithDict:testDict];
    NSString *expectedString = @"{\n  \"key\" : \"value\"\n}";
    XCTAssertTrue([expectedString isEqualToString:jsonString], @"JSON String not valid: \n%@\nis not equal to\n%@", jsonString, expectedString);
}

- (void)testBadObject 
{
    UIView *view = [[UIView alloc] init];
    NSDictionary *testDict = @{@"key": view};
    NSString *jsonString = [KDictionary jsonStringWithDict:testDict];
    XCTAssertTrue((jsonString == nil), @"JSON string should be nil");
}

@end
