//
//  KSystemCollectorTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/18/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KSystemCollector.h"
#import "KDataCollectorMock.h"

#pragma mark - Tests

@interface KSystemCollectorTests : XCTestCase

@property (strong) KSystemCollector *collector;

@end

@implementation KSystemCollectorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [KDataCollectorMock sharedCollector]; // Make sure the instance for the mock is created before running any tests
    self.collector = [[KSystemCollector alloc] init];
}

- (void)tearDown 
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormal
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 0, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyOSVersion], @"No OS version present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyMobileModel], @"No model present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyTotalMemory], @"No memory present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLanguageAndCountry], @"No language and country present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyScreenDimensions], @"No screen dimensions present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocalDateTimeEpoch], @"No local datetime present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyTimezoneCurrent], @"No timezone current present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyTimezoneAugust], @"No timezone offset August present");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyTimezoneFebruary], @"No timezone offset February present");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
