//
//  KLocationCollectorTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/18/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "KLocationCollector.h"
#import "KLocationCollectorMock.h"
#import "KDataCollectorMock.h"

#pragma mark - Tests

@interface KLocationCollectorTests : XCTestCase

@property (strong) KLocationCollectorMock *collector;

@end

@implementation KLocationCollectorTests

- (void)setUp 
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [KDataCollectorMock sharedCollector]; // Make sure the instance for the mock is created before running any tests
    self.collector = [[KLocationCollectorMock alloc] initWithConfig:KLocationCollectorConfigRequestPermission withTimeoutInMS:1000];
    [KLocationCollectorMock resetMocks];
}

- (void)tearDown 
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRealManager 
{
    [KLocationCollectorMock setMockOverrideLocationClassName:NO];
    XCTAssertTrue([[self.collector locationManagerClassName] isEqualToString:@"CLLocationManager"], @"Class name isn't CLLocationManager");
}

- (void)testPassiveDisabledNoPermission
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    self.collector.config = KLocationCollectorConfigPassive;
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

- (void)testPassiveEnabledNotDetermined 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    self.collector.config = KLocationCollectorConfigPassive;
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

- (void)testPassiveEnabledDenied 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusDenied];
    self.collector.config = KLocationCollectorConfigPassive;
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

- (void)testPassiveEnabledPermission 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    self.collector.config = KLocationCollectorConfigPassive;
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 1, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationDate], @"No location date");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationLatitude], @"No latitude");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationLongitude], @"No longitude");
        //KIOS-20: Reverse Geocoding Test Case
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyCity], @"No City");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyState], @"No State");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyCountry], @"No Country");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyISO], @"No Country code");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testRequestEnabledRequestPermissionThenDenied 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusDenied];
    self.collector.config = KLocationCollectorConfigRequestPermission;
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

- (void)testRequestEnabledRequestPermissionThenAllowed 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    self.collector.config = KLocationCollectorConfigRequestPermission;
    [self.collector collectForSession:sessionID completion:^(BOOL success, NSError * _Nullable error, NSDictionary * collectedData, NSDictionary * softErrors) {
        XCTAssertTrue([self.collector.sessionID isEqualToString:self.collector.sessionID], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Success should be YES");
        XCTAssertTrue(softErrors.count == 1, @"Should be no soft errors");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationDate], @"No location date");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationLatitude], @"No latitude");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyLocationLongitude], @"No longitude");
        //KIOS-20: Reverse Geocoding Test Case
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyCity], @"No City");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyState], @"No State");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyCountry], @"No Country");
        XCTAssertNotNil([collectedData objectForKey:KDataCollectorPostKeyISO], @"No Country Code");
        [expectation fulfill];
    } debugDelegate:nil];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testRequestEnabledRequestPermissionThenAllowedThenError 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [KLocationCollectorMock setMockError:YES];
    self.collector.config = KLocationCollectorConfigRequestPermission;
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

- (void)testRequestEnabledRequestPermissionThenBadAccuracy 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionID = @"TESTSESSION";
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [KLocationCollectorMock setMockBadAccuracy:YES];
    self.collector.config = KLocationCollectorConfigRequestPermission;
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

@end
