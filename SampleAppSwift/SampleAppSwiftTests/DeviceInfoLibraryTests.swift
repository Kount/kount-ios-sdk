//
//  DeviceInfoLibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 26-08-24.
//

import XCTest
import UIKit
@testable import SampleAppSwift

final class DeviceInfoLibraryTests: XCTestCase {
    var mockObserver: MockLibraryDataObserver!
    var library: DeviceInfoLibrary!
    var mockDevice: MockDevice!
    
    override func setUp() {
        super.setUp()
        mockObserver = MockLibraryDataObserver()
        mockDevice = MockDevice()
        library = DeviceInfoLibrary(observer: mockObserver, device: mockDevice)
    }
    
    override func tearDown() {
        library.stop()
        LibraryManager.shared.resetForTesting() // Reset the LibraryManager
        mockObserver = nil
        mockDevice = nil
        library = nil
        super.tearDown()
    }
    
    func testStart_ShouldAddObserversAndFetchInitialDeviceInfo() {
        // Configure the mock device with known values
        mockDevice.mockOrientation = .portrait
        mockDevice.mockBatteryState = .unknown
        mockDevice.mockBatteryLevel = -1.0 // Represents "Unknown"
        
        // Create an expectation to wait for the async data fetch
        let initialDataExpectation = self.expectation(description: "Waiting for initial data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            initialDataExpectation.fulfill()
        }
        
        // Start the library
        library.start()
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Initial data fetch failed with error: \(error)")
            }
        }
        
        // Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .deviceInfo)
        XCTAssertEqual(mockObserver.updatedData?["Device Name"], mockDevice.name)
        XCTAssertEqual(mockObserver.updatedData?["System Name"], mockDevice.systemName)
        XCTAssertEqual(mockObserver.updatedData?["System Version"], mockDevice.systemVersion)
        XCTAssertEqual(mockObserver.updatedData?["Model"], mockDevice.model)
        XCTAssertEqual(mockObserver.updatedData?["Orientation"], UIDevice.orientationDescription(mockDevice.orientation))
        XCTAssertEqual(mockObserver.updatedData?["Battery State"], UIDevice.batteryStateDescription(mockDevice.batteryState))
        XCTAssertEqual(mockObserver.updatedData?["Battery Level"], mockDevice.batteryLevel >= 0 ? "\(Int(mockDevice.batteryLevel * 100))%" : "Unknown")
    }
    
    func testStop_ShouldRemoveObservers() {
        // Step 1: Handle initial data fetch
        let initialDataExpectation = self.expectation(description: "Waiting for initial data fetch")
        mockObserver.addUpdateCallback {
            initialDataExpectation.fulfill()
        }
        library.start()
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Initial data fetch failed with error: \(error)")
            }
        }
        
        // Step 2: Reset observer's data and clear previous callbacks
        mockObserver.updatedData = nil
        mockObserver.updatedLibraryType = nil
        mockObserver.clearUpdateCallbacks()
        
        // Step 3: Stop the library
        library.stop()
        
        // Step 4: Create an expectation that should NOT be fulfilled
        let noUpdateExpectation = self.expectation(description: "Observer should not be called after stop")
        noUpdateExpectation.isInverted = true // This expectation should NOT be fulfilled
        
        // Step 5: Set the observer's callback to fulfill the expectation if called
        mockObserver.addUpdateCallback {
            noUpdateExpectation.fulfill()
        }
        
        // Step 6: Post a notification that would normally trigger an update
        NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Step 7: Wait to see if the expectation is fulfilled (it should NOT be)
        waitForExpectations(timeout: 0.2) { error in
            // If the expectation is fulfilled, the test will automatically fail
        }
        
        // Step 8: Assert that updatedData and updatedLibraryType remain unchanged (still nil)
        XCTAssertNil(mockObserver.updatedData)
        XCTAssertNil(mockObserver.updatedLibraryType)
    }
    
    func testBatteryStateDidChange_ShouldNotifyObserver() {
        // Step 1: Handle initial data fetch
        let initialDataExpectation = self.expectation(description: "Waiting for initial data fetch")
        mockObserver.addUpdateCallback {
            initialDataExpectation.fulfill()
        }
        library.start()
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Initial data fetch failed with error: \(error)")
            }
        }
        
        // Step 2: Reset observer's data and clear previous callbacks
        mockObserver.updatedData = nil
        mockObserver.updatedLibraryType = nil
        mockObserver.clearUpdateCallbacks()
        
        // Step 3: Create expectation for battery state change
        let batteryStateExpectation = self.expectation(description: "Waiting for battery state update")
        mockObserver.addUpdateCallback {
            batteryStateExpectation.fulfill()
        }
        
        // Step 4: Simulate a battery state change
        mockDevice.mockBatteryState = .charging
        NotificationCenter.default.post(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
        // Step 5: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Battery state update failed with error: \(error)")
            }
        }
        
        // Step 6: Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .deviceInfo)
        XCTAssertEqual(mockObserver.updatedData?["Battery State"], "Charging")
    }
    
    func testBatteryLevelDidChange_ShouldNotifyObserver() {
        // Step 1: Handle initial data fetch
        let initialDataExpectation = self.expectation(description: "Waiting for initial data fetch")
        mockObserver.addUpdateCallback {
            initialDataExpectation.fulfill()
        }
        library.start()
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Initial data fetch failed with error: \(error)")
            }
        }
        
        // Step 2: Reset observer's data and clear previous callbacks
        mockObserver.updatedData = nil
        mockObserver.updatedLibraryType = nil
        mockObserver.clearUpdateCallbacks()
        
        // Step 3: Create expectation for battery level change
        let batteryLevelExpectation = self.expectation(description: "Waiting for battery level update")
        mockObserver.addUpdateCallback {
            batteryLevelExpectation.fulfill()
        }
        
        // Step 4: Simulate a battery level change
        mockDevice.mockBatteryLevel = 0.5
        NotificationCenter.default.post(name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        
        // Step 5: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Battery level update failed with error: \(error)")
            }
        }
        
        // Step 6: Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .deviceInfo)
        XCTAssertEqual(mockObserver.updatedData?["Battery Level"], "50%")
    }
    
    func testOrientationDidChange_ShouldNotifyObserver() {
        // Step 1: Handle initial data fetch
        let initialDataExpectation = self.expectation(description: "Waiting for initial data fetch")
        mockObserver.addUpdateCallback {
            initialDataExpectation.fulfill()
        }
        library.start()
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Initial data fetch failed with error: \(error)")
            }
        }
        
        // Step 2: Reset observer's data and clear previous callbacks
        mockObserver.updatedData = nil
        mockObserver.updatedLibraryType = nil
        mockObserver.clearUpdateCallbacks()
        
        // Step 3: Create expectation for orientation change
        let orientationExpectation = self.expectation(description: "Waiting for orientation update")
        mockObserver.addUpdateCallback {
            orientationExpectation.fulfill()
        }
        
        // Step 4: Simulate an orientation change
        mockDevice.mockOrientation = .landscapeLeft
        NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Step 5: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Orientation update failed with error: \(error)")
            }
        }
        
        // Step 6: Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .deviceInfo)
        XCTAssertEqual(mockObserver.updatedData?["Orientation"], "Landscape Left")
    }
    
    func testOrientationDescription() {
        XCTAssertEqual(UIDevice.orientationDescription(.faceUp), "Face Up")
        XCTAssertEqual(UIDevice.orientationDescription(.faceDown), "Face Down")
        XCTAssertEqual(UIDevice.orientationDescription(.portrait), "Portrait")
        XCTAssertEqual(UIDevice.orientationDescription(.portraitUpsideDown), "Portrait Upside Down")
        XCTAssertEqual(UIDevice.orientationDescription(.landscapeLeft), "Landscape Left")
        XCTAssertEqual(UIDevice.orientationDescription(.landscapeRight), "Landscape Right")
        XCTAssertEqual(UIDevice.orientationDescription(.unknown), "Unknown")
    }
    
    func testBatteryStateDescription() {
        XCTAssertEqual(UIDevice.batteryStateDescription(.unknown), "Unknown")
        XCTAssertEqual(UIDevice.batteryStateDescription(.unplugged), "Unplugged")
        XCTAssertEqual(UIDevice.batteryStateDescription(.charging), "Charging")
        XCTAssertEqual(UIDevice.batteryStateDescription(.full), "Full")
    }
}
