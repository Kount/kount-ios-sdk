//
//  AltimeterAbsoluteLibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import XCTest
import CoreMotion
@testable import SampleAppSwift

final class AltimeterAbsoluteLibraryTests: XCTestCase {
    var mockAltimeter: MockAbsoluteAltitude!
    var mockObserver: MockLibraryDataObserver!
    var library: AltimeterAbsoluteLibrary!

    override func setUp() {
        super.setUp()
        mockAltimeter = MockAbsoluteAltitude()
        mockObserver = MockLibraryDataObserver()
        library = AltimeterAbsoluteLibrary(observer: mockObserver, altimeter: mockAltimeter, altimeterAvailability: MockAbsoluteAltitude.self)
    }

    func testStart_WhenAbsoluteAltitudeAvailable_ShouldStartUpdates() {
        MockAbsoluteAltitude.isAvailable = true
        library.start()
        XCTAssertNotNil(mockAltimeter.startAbsoluteUpdatesHandler)
    }

    func testStart_WhenAbsoluteAltitudeNotAvailable_ShouldNotStartUpdates() {
        MockAbsoluteAltitude.isAvailable = false
        library.start()
        XCTAssertNil(mockAltimeter.startAbsoluteUpdatesHandler)
    }

    func testStart_WhenDataReceived_ShouldNotifyObserver() {
        MockAbsoluteAltitude.isAvailable = true
        library.start()
        
        let data = MockCMAbsoluteAltitudeData(altitude: 100.0, accuracy: 5.0, precision: 0.5)
        mockAltimeter.startAbsoluteUpdatesHandler?(data, nil)
        
        XCTAssertEqual(mockObserver.updatedLibraryType, .altimeterAbsolute)
        XCTAssertEqual(mockObserver.updatedData?["Altitude"], "100.00 m")
        XCTAssertEqual(mockObserver.updatedData?["Accuracy"], "5.00 m")
        XCTAssertEqual(mockObserver.updatedData?["Precision"], "0.50 m")
    }

    func testStart_WhenDataReceivedWithError_ShouldNotNotifyObserver() {
        MockAbsoluteAltitude.isAvailable = true
        library.start()
        
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        mockAltimeter.startAbsoluteUpdatesHandler?(nil, error)
        
        XCTAssertNil(mockObserver.updatedData)
        XCTAssertNil(mockObserver.updatedLibraryType)
    }

    func testStop_ShouldStopUpdates() {
        library.stop()
        // No specific assertions here, just ensuring the method can be called without issue
    }
}
