//
//  AltimeterRelativeLibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 08-07-24.
//

import XCTest
import CoreMotion
@testable import SampleAppSwift

final class AltimeterRelativeLibraryTests: XCTestCase {
    var mockAltimeter: MockRelativeAltitude!
    var mockObserver: MockLibraryDataObserver!
    var library: AltimeterRelativeLibrary!

    override func setUp() {
        super.setUp()
        mockAltimeter = MockRelativeAltitude()
        mockObserver = MockLibraryDataObserver()
        library = AltimeterRelativeLibrary(observer: mockObserver, altimeter: mockAltimeter, altimeterAvailability: MockRelativeAltitude.self)
    }

    func testStart_WhenRelativeAltitudeAvailable_ShouldStartUpdates() {
        MockRelativeAltitude.isAvailable = true
        library.start()
        XCTAssertNotNil(mockAltimeter.startRelativeUpdatesHandler)
    }

    func testStart_WhenRelativeAltitudeNotAvailable_ShouldNotStartUpdates() {
        MockRelativeAltitude.isAvailable = false
        library.start()
        XCTAssertNil(mockAltimeter.startRelativeUpdatesHandler)
    }

    func testStart_WhenDataReceived_ShouldNotifyObserver() {
        MockRelativeAltitude.isAvailable = true
        library.start()
        
        let data = MockCMRelativeAltitudeData(pressure: 1000.0, relativeAltitude: 50.0)
        mockAltimeter.startRelativeUpdatesHandler?(data, nil)
        
        XCTAssertEqual(mockObserver.updatedLibraryType, .altimeterRelative)
        XCTAssertEqual(mockObserver.updatedData?["Pressure"], "1000.00 hPa")
        XCTAssertEqual(mockObserver.updatedData?["Altitude"], "50.00 m")
    }
    
    func testStart_WhenDataReceivedWithError_ShouldNotNotifyObserver() {
        MockRelativeAltitude.isAvailable = true
        library.start()
        
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        mockAltimeter.startRelativeUpdatesHandler?(nil, error)
        
        XCTAssertNil(mockObserver.updatedData)
        XCTAssertNil(mockObserver.updatedLibraryType)
    }

    func testStop_ShouldStopUpdates() {
        library.stop()
    }
}
