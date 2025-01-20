//
//  AccelerometerLibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import XCTest
import CoreMotion
@testable import SampleAppSwift

final class AccelerometerLibraryTests: XCTestCase {
    var mockMotionManager: MockAccelerometerManager!
    var mockObserver: MockLibraryDataObserver!
    var library: AccelerometerLibrary!

    override func setUp() {
        super.setUp()
        mockMotionManager = MockAccelerometerManager()
        mockObserver = MockLibraryDataObserver()
        library = AccelerometerLibrary(observer: mockObserver, motionManager: mockMotionManager)
    }

    func testStart_WhenAccelerometerAvailable_ShouldStartUpdates() {
        library.start()
        XCTAssertTrue(mockMotionManager.isAccelerometerAvailable)
        XCTAssertNotNil(mockMotionManager.startUpdatesHandler)
    }

    func testStart_WhenAccelerometerNotAvailable_ShouldNotStartUpdates() {
        mockMotionManager.isAccelerometerAvailable = false
        library.start()
        XCTAssertNil(mockMotionManager.startUpdatesHandler)
    }

    func testStart_WhenDataReceived_ShouldNotifyObserver() {
        library.start()
        let acceleration = CMAcceleration(x: 1.0, y: 2.0, z: 3.0)
        let data = MockCMAccelerometerData(acceleration: acceleration)

        mockMotionManager.startUpdatesHandler?(data, nil)

        XCTAssertEqual(mockObserver.updatedLibraryType, .accelerometer)
        XCTAssertEqual(mockObserver.updatedData?["X axis"], "1.00 m/s²")
        XCTAssertEqual(mockObserver.updatedData?["Y axis"], "2.00 m/s²")
        XCTAssertEqual(mockObserver.updatedData?["Z axis"], "3.00 m/s²")
    }

    func testStart_WhenDataReceivedWithError_ShouldNotNotifyObserver() {
        library.start()
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        mockMotionManager.startUpdatesHandler?(nil, error)
        XCTAssertNil(mockObserver.updatedData)
        XCTAssertNil(mockObserver.updatedLibraryType)
    }

    func testGetAccelerometerPosition() {
        let horizontalThreshold: Double = 0.95
        let tiltThreshold: Double = 0.5

        // Test Horizontal position
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: 0, z: -horizontalThreshold - 0.1)), "Horizontal")
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: 0, z: horizontalThreshold + 0.1)), "Horizontal")

        // Test Vertical position
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: -horizontalThreshold - 0.1, z: 0)), "Vertical")
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: horizontalThreshold + 0.1, z: 0)), "Vertical")

        // Test Tilted position
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: -tiltThreshold - 0.1, z: -tiltThreshold - 0.1)), "Tilted")

        // Test Landscape position
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: 0, z: 0)), "Landscape")
        XCTAssertEqual(library.getAccelerometerPosition(CMAcceleration(x: 0, y: tiltThreshold - 0.1, z: tiltThreshold - 0.1)), "Landscape")
    }

    func testStop_ShouldStopUpdates() {
        library.stop()
        // No specific assertions here, just ensuring the method can be called without issue
    }
}
