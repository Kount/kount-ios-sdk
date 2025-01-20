//
//  KDataCollectorTests.m
//  KountDataCollector
//
//  Created by Keith Feldman on 2/18/16.
//  Copyright © 2016 Kount Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KDataCollector_Internal.h"
#import "KDataCollectorMock.h"
#import "RegExValidation.h"
#import "KountDataCollector/KountAnalyticsViewController.h"
#import "NetworkValidation.h"
#import "NetworkValidationMock.h"

@interface KDataCollectorTests : XCTestCase <KDataCollectorDebugDelegate>

@end

@implementation KDataCollectorTests

NSString *const KDataCollectorRegExSessionID = @"^[A-Za-z0-9-_]{1,36}$";

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [KDataCollectorMock sharedCollector]; // Make sure the instance for the mock is created before running any tests
    [KLocationCollectorMock resetMocks];
    [NetworkValidation reset];
    [NetworkValidationMock reset];
    [KDataCollectorMock resetMocks];
    [[KDataCollectorMock sharedCollector] setDebug:YES];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"999999"];
    [[KDataCollectorMock sharedCollector] setServer:@"https://mbl.kaptcha.com/"];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigSkip];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNormal  {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigPassive];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        XCTAssertTrue([sessionID isEqualToString:@"TESTSESSION"], @"Session ID doesn't match");
        XCTAssertTrue(success, @"Should have been successful");
        XCTAssertNil(error, @"Should be no errors");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testRequestPermission {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigRequestPermission];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self permissionAsserts:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testRequestPermissionThenDenied {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [KLocationCollectorMock setMockRequestAuthorization:YES];
    [KLocationCollectorMock setMockRequestAuthorizationReturnStatus:kCLAuthorizationStatusDenied];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigRequestPermission];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self permissionAsserts:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testSkipLocation {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigSkip];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self permissionAsserts:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//MARK: - UnitTest MerchantID

- (void)testValidAnalyticsMerchantID15Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"123456789012345"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validMerchantIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsMerchantID6Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"999999"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validMerchantIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantIDNull {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:nil];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantID14DigitsPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"12345678901234 "];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantIDMoreThan15Characters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234567890123456"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantIDSimbols {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"&#%$&#%$”#”%#”$"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantID15DigitsAndLetters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234567890abcde"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantIDEmpty {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@""];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantIDSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@" "];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsMerchantID5DigitsPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234 5"];
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:@"TESTSESSION" analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidMerchantID6Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"999999"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validMerchantIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidMerchantID15Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"123456789012345"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validMerchantIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantIDNull {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:nil];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantID14DigitsPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"12345678901234 "];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantIDMoreThan15Characters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234567890123456"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


- (void)testInvalidMerchantIDSimbols {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"&#%$&#%$”#”%#”$"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantID15DigitsAndLetters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234567890abcde"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantIDEmpty {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@""];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantIDSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@" "];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidMerchantID5DigitsPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setMerchantID:@"1234 5"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

//MARK: - UnitTest SessionID
- (void)testValidAnalyticsSessionID1Digit {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID1Letter {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"H";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"12345678901234512345678901234565";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32Letters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"gyemajirlsoptfavjerklsuitantiayf";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID36Alphanumeric {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"12fr56789hytad51234567fgr12345657890";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID36AlphanumericPlusDashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu-9012-3451-2bj5-6789-012f-4";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID36AlphanumericPlusUndescores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234_YALG_9012_3451_hdya_6789_0123_4";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32AlphanumericPlusDashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu-9012-3451-2bj5-6789-012f-4";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32AlphanumericPlusUnderscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234_YALG_9012_3451_hdya_6789_0123_4";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID1Dash {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"-";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID1Underscore {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"_";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID36Dashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"------------------------------------";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID36Underscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"____________________________________";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32Dashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"------------------------------------";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionID32Underscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"________________________________";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionIDNull {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = nil;
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionID sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidAnalyticsSessionIDEmpty {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self validSessionIDAsserts:sessionID sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionIDSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @" ";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionID1DigitPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1 ";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionID31AlphanumericPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1HJDFIW74LAHTUI8WKSBGKSU3BTUWKD ";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionID35AlphanumericPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1HJDFIW74LAHTUI8WKSBGKSU3BTUWKDFIR6 ";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionIDSpecialCharacters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"&#%$”#”%#”$";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidAnalyticsSessionIDMoreThan36Characters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu_9012-3451_2bj5-6789-012f-4t";
    [[KountAnalyticsViewController sharedInstance] setEnvironmentForAnalytics: [KDataCollector.sharedCollector environment]];
    [[KountAnalyticsViewController sharedInstance] collect:sessionId analyticsSwitch:true completion:^(NSString * _Nonnull sessionID, _Bool success, NSError * _Nullable error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID1Digit {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID1Letter {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"H";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32Digits {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"12345678901234512345678901234565";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32Letters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"gyemajirlsoptfavjerklsuitantiayf";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID36Alphanumeric {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"12fr56789hytad51234567fgr12345657890";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID36AlphanumericPlusDashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu-9012-3451-2bj5-6789-012f-4";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID36AlphanumericPlusUndescores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234_YALG_9012_3451_hdya_6789_0123_4";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32AlphanumericPlusDashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu-9012-3451-2bj5-6789-012f-4";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32AlphanumericPlusUnderscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234_YALG_9012_3451_hdya_6789_0123_4";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID1Dash {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"-";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID1Underscore {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"_";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID36Dashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"------------------------------------";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID36Underscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"____________________________________";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32Dashes {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"------------------------------------";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidSessionID32Underscores {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"________________________________";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:sessionId sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionIDNull {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = nil;
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionIDEmpty {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionIDSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @" ";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionID1DigitPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1 ";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionID31AlphanumericPlusSpace {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1HJDFIW74LAHTUI8WKSBGKSU3BTUWKD ";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionID35AlphanumericPlusSpace
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1HJDFIW74LAHTUI8WKSBGKSU3BTUWKDFIR6 ";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionIDSpecialCharacters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"&#%$”#”%#”$";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testInvalidSessionIDMoreThan36Characters {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    NSString *sessionId = @"1234-5kiu_9012-3451_2bj5-6789-012f-4t";
    [[KDataCollectorMock sharedCollector] collectForSession:sessionId completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testValidRegExSessionID1CharacterLoop {
    
    NSArray *specialCharactersArray = @[@"a", @"b", @"C", @"D", @"e", @"F", @"G", @"h", @"i", @"j", @"k", @"L", @"m", @"n", @"O", @"p", @"q", @"R", @"s", @"T", @"u", @"v", @"w", @"x", @"Y", @"z"];
    for (NSString *specialCharacter in specialCharactersArray) {
        BOOL isMatching = [RegExValidation matchRegEx:specialCharacter pattern:KDataCollectorRegExSessionID];
        XCTAssertTrue(isMatching, @"Should have NOT been False");
    }
}

- (void)testValidRegExSessionID1DigitLoop {
    NSArray *specialCharactersArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    for (NSString *specialCharacter in specialCharactersArray) {
        BOOL isMatching = [RegExValidation matchRegEx:specialCharacter pattern:KDataCollectorRegExSessionID];
        XCTAssertTrue(isMatching, @"Should have NOT been False");
    }
}

- (void)testValidRegExSessionID1DSpecialCharacterLoop {
    NSArray *specialCharactersArray = @[@"-", @"_"];
    for (NSString *specialCharacter in specialCharactersArray) {
        BOOL isMatching = [RegExValidation matchRegEx:specialCharacter pattern:KDataCollectorRegExSessionID];
        XCTAssertTrue(isMatching, @"Should have NOT been False");
    }
}

- (void)testIvalidRegExSessionID1SpecialCharacterLoop {
    NSArray *specialCharactersArray = @[@"ℊ", @"ü", @"ç", @"ᒏ", @"⍲", @"⍳", @"⍴", @"⍵", @"⍷", @"⍸", @"⍹", @"⍺", @"ㄓ", @"ㄔ", @"ñ", @"ℋ", @"ℌ", @"ℍ", @"ℎ", @"ℏ", @"ℐ", @"ℑ", @"ℒ", @"ℓ", @"Æ", @"℔"];
    
    for (NSString *specialCharacter in specialCharactersArray) {
        BOOL isMatching = [RegExValidation matchRegEx:specialCharacter pattern:KDataCollectorRegExSessionID];
        XCTAssertFalse(isMatching, @"Should have NOT been True");
    }
}

- (void)testInvalidURL  {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] setServer:@"!"];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidMerchantIDAndSessionIDAsserts:sessionID success:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testDidNotSend {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KDataCollectorMock setMockDidNotSend:YES];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        XCTAssertFalse(success, @"Should have NOT been successful");
        XCTAssertNotNil(error, @"Should have been an error");
        XCTAssertEqual(error.code, KDataCollectorErrorCodeNSError);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testGetNetworkFailure {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [NetworkValidationMock setMockNetworkGetFailure:YES];
    [NetworkValidation setMockOverrideClassName:NO];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self invalidNetworkAsserts:success error:error];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testNoNetwork {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [NetworkValidationMock setMockNetworkFlags:0];
    [NetworkValidation setMockOverrideClassName:NO];
    [[KDataCollectorMock sharedCollector] collectForSession:@"TESTSESSION" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testPush1 {
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
    [KLocationCollectorMock setMockLocationEnabled:YES];
    [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigPassive];
    [[KDataCollectorMock sharedCollector] collectForSession:@"Push1Session1" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:@"Push1Session1" sessionIDOut:sessionID success:success error:error];
        [expectation fulfill];
    }];
    XCTestExpectation *expectation2 = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] collectForSession:@"Push1Session2" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:@"Push1Session2" sessionIDOut:sessionID success:success error:error];
        [expectation2 fulfill];
    }];
    XCTestExpectation *expectation3 = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    [[KDataCollectorMock sharedCollector] collectForSession:@"Push1Session3" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
        [self validSessionIDAsserts:@"Push1Session3" sessionIDOut:sessionID success:success error:error];
        [expectation3 fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testPush2 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    dispatch_async(queue3, ^{
        [KLocationCollectorMock setMockDefaultAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
        [KLocationCollectorMock setMockLocationEnabled:YES];
        [[KDataCollectorMock sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigPassive];
        
        [[KDataCollectorMock sharedCollector] collectForSession:@"Push2Session1" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
            [self validSessionIDAsserts:@"Push2Session1" sessionIDOut:sessionID success:success error:error];
            [expectation fulfill];
        } debugDelegate:self];
    });
    XCTestExpectation *expectation2 = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    dispatch_async(queue2, ^{
        [[KDataCollectorMock sharedCollector] collectForSession:@"Push2Session2" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
            [self validSessionIDAsserts:@"Push2Session2" sessionIDOut:sessionID success:success error:error];
            [expectation2 fulfill];
        } debugDelegate:self];
    }); 
    XCTestExpectation *expectation3 = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    dispatch_async(queue, ^{
        [[KDataCollectorMock sharedCollector] collectForSession:@"Push2Session3" completion:^(NSString *_Nonnull sessionID, BOOL success, NSError *_Nonnull error) {
            [self validSessionIDAsserts:@"Push2Session3" sessionIDOut:sessionID success:success error:error];
            [expectation3 fulfill];
        } debugDelegate:self];
    });
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testEnvironment {
    [[KDataCollectorMock sharedCollector] setEnvironment:KEnvironmentProduction];
    XCTAssertEqual(@"https://ssl.kaptcha.com/", [[KDataCollectorMock sharedCollector] server], "Environment didn't match server");
    [[KDataCollectorMock sharedCollector] setEnvironment:KEnvironmentTest];
    XCTAssertEqual(@"https://tst.kaptcha.com/", [[KDataCollectorMock sharedCollector] server], "Environment didn't match server");
}

//MARK: - Asserts Functions
- (void)validSessionIDAsserts:(NSString *)sessionIDIn sessionIDOut:(NSString *)sessionIDOut success:(BOOL)success error:(NSError *)error  {
    XCTAssertTrue(success, @"Should have been successful");
    XCTAssertNil(error, @"Should be no errors");
    XCTAssertTrue([sessionIDOut isEqualToString:sessionIDIn], @"Session ID match");
}

- (void)validMerchantIDAsserts:(NSString *)sessionID success:(BOOL)success error:(NSError *)error  {
    XCTAssertTrue(success, @"Should have been successful");
    XCTAssertNil(error, @"Should be no errors");
    XCTAssertTrue([sessionID isEqualToString:@"TESTSESSION"], @"Session ID match");
}

- (void)invalidMerchantIDAndSessionIDAsserts:(NSString *)sessionID success:(BOOL)success error:(NSError *)error  {
    XCTAssertFalse(success, @"Should have NOT been successful");
    XCTAssertNotNil(error, @"Should have been an error");
    XCTAssertEqual(error.code, KDataCollectorErrorCodeBadParameter);
}
- (void)invalidNetworkAsserts:(BOOL)success error:(NSError *)error {
    XCTAssertFalse(success, @"Should have NOT been successful");
    XCTAssertNotNil(error, @"Should have been an error");
    XCTAssertEqual(error.code, KDataCollectorErrorCodeNoNetwork);
}

- (void)permissionAsserts:(BOOL)success error:(NSError *)error {
    XCTAssertTrue(success, @"Should have been successful");
    XCTAssertNil(error, @"Should be no errors");
}

#pragma mark Collector Delegate

- (void)collectorDebugMessage:(NSString *)message {
    
}

- (void)collectorStarted:(NSString *)collectorName {
    
}

- (void)collectorDone:(NSString *)collectorName success:(BOOL)success error:(NSError *)error {
    
}

@end
