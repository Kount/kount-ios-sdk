//
//  KFingerprintCollectorTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/18/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KFingerprintCollector.h"
#import "KFingerprintCollectorMock.h"
#import "KDataCollectorMock.h"

#pragma mark - Tests

@interface KFingerprintCollectorTests : XCTestCase

@property (strong) KTestFingerprintCollector *collector;

@end

@implementation KFingerprintCollectorTests

- (void)setUp 
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [KDataCollectorMock sharedCollector]; // Make sure the instance for the mock is created before running any tests
    self.collector = [[KTestFingerprintCollector alloc] init];
    self.collector.mockCookieWriteFail = NO;
    self.collector.done = NO;
    [self removeCookieFile];
}

- (void)tearDown 
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)writeGarbageCookieFile
{
    NSString *cookieFilePath = [self.collector cookieFilePath];
    NSString *test = @"TESTSTRINGFORFILE";
    [test writeToFile:cookieFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)removeCookieFile 
{
    NSString *cookieFilePath = [self.collector cookieFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:cookieFilePath error:nil];
}

- (void)testNormal
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    __block NSMutableString *cookieFirst = [NSMutableString string];
    __block NSMutableString *cookieSecond = [NSMutableString string];
    __block NSMutableString *previousCookie = [NSMutableString string];
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 0, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyDeviceCookie], @"No cookie present");
        cookieFirst = [collectedData objectForKey:KDataCollectorPostKeyDeviceCookie];
        previousCookie = [collectedData objectForKey:KDataCollectorPostKeyOldDeviceCookie];
        XCTAssertTrue(self.collector.done, @"Collector not marked as done");
        XCTAssertNil(previousCookie, @"Previous should be nil");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    self.collector.done = NO;
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 0, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyDeviceCookie], @"No cookie present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyOldDeviceCookie], @"No old cookie present");
        cookieSecond = [collectedData objectForKey:KDataCollectorPostKeyDeviceCookie];
        previousCookie = [collectedData objectForKey:KDataCollectorPostKeyOldDeviceCookie];
        XCTAssertTrue(self.collector.done, @"Collector not marked as done");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    // PreviousCookie and CookieFirst are the same object but when saved in a string are different since the properties are saved in different order
    NSArray *arrayPreviousCookie = [previousCookie componentsSeparatedByString:@"\""];
    NSArray *arrayCookieFirst = [cookieFirst componentsSeparatedByString:@"\""];
    XCTAssertTrue([cookieFirst isEqualToString:cookieSecond], @"Cookies are not equal, but should be");
    XCTAssertTrue([arrayPreviousCookie[3] isEqualToString:arrayCookieFirst[7]], @"Cookies IOS_IDFV are not equal, but should be");
    XCTAssertTrue([arrayPreviousCookie[7] isEqualToString:arrayCookieFirst[3]], @"Cookies UID are not equal, but should be");
}

- (void)testWriteCookieError
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    self.collector.mockCookieWriteFail = YES;
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertFalse(success, @"Success should be NO");
        XCTAssertTrue(softErrors.count > 0, @"Should be soft errors");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testReadCookieError
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    __block NSMutableString *cookieFirst = [NSMutableString string];
    __block NSMutableString *previousCookie = [NSMutableString string];
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 0, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyDeviceCookie], @"No cookie present");
        cookieFirst = [collectedData objectForKey:KDataCollectorPostKeyDeviceCookie];
        previousCookie = [collectedData objectForKey:KDataCollectorPostKeyOldDeviceCookie];
        XCTAssertTrue(self.collector.done, @"Collector not marked as done");
        XCTAssertNil(previousCookie, @"Previous should be nil");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    self.collector.done = NO;
    [self writeGarbageCookieFile];
    expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 0, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyDeviceCookie], @"No cookie present");
        cookieFirst = [collectedData objectForKey:KDataCollectorPostKeyDeviceCookie];
        previousCookie = [collectedData objectForKey:KDataCollectorPostKeyOldDeviceCookie];
        XCTAssertTrue(self.collector.done, @"Collector not marked as done");
        XCTAssertNil(previousCookie, @"Previous should be nil");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
