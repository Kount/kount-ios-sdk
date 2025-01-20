//
//  KCollectorTaskBaseTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/22/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KCollectorTaskBase.h"
#import "KDataCollector_Internal.h"
#import "KDataCollectorMock.h"
#import "KCollectorTaskBaseMock.h"

@interface KCollectorTaskBaseTests : XCTestCase <KDataCollectorDebugDelegate>

@property (strong) KCollectorTaskBaseMock *collector;

@end

@implementation KCollectorTaskBaseTests

- (void)setUp 
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [KDataCollectorMock sharedCollector]; // Make sure the instance for the mock is created before running any tests
    [KCollectorTaskBaseMock resetMocks];
    self.collector = [[KCollectorTaskBaseMock alloc] init];
}

- (void)tearDown 
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddDataPoint 
{
    XCTAssertThrowsSpecific([self.collector addDataPoint:[NSDictionary dictionary] forKey:@"TEST1"], NSException, @"should throw an exception");
    XCTAssertTrue(self.collector.data.count == 0, @"Should be no entries");
    [self.collector addDataPoint:@1 forKey:@"TEST2"];
    XCTAssertTrue(self.collector.data.count == 1, @"Should be 1 entry");
    [self.collector addDataPoint:@"VALUE" forKey:@"TEST3"];
    XCTAssertTrue(self.collector.data.count == 2, @"Should be 2 entries");
}

- (void)testCollectForSession 
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KCollectorTaskBaseMock setMockOverrideCollect:YES];
    [self.collector collectForSession:@"Another" completion:^(BOOL success, NSError *_Nullable error, NSDictionary *_Nonnull collectedData, NSDictionary *_Nonnull softErrors) {
        XCTAssertTrue(success, @"Success should be YES");
        [expectation fulfill];
    } debugDelegate:self];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testCollectAssert 
{
    XCTAssertThrowsSpecific([self.collector collect], NSException, @"should throw an exception");
}

#pragma mark Collector Delegate

- (void)collectorDebugMessage:(NSString *)message 
{

}

- (void)collectorStarted:(NSString *)collectorName 
{

}

- (void)collectorDone:(NSString *)collectorName success:(BOOL)success error:(NSError *)error 
{

}

@end
