//
//  KernelMemoryCPULibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Felipe Plaza on 03-09-24.
//

import XCTest
import UIKit
@testable import SampleAppSwift

final class KernelHardwareLibraryTests: XCTestCase {
    
    var mockObserver: MockLibraryDataObserver!
    var mockSysctlProvider: MockSysctlProvider!
    var library: KernelHardwareLibrary!
    
    override func setUp() {
        super.setUp()
        mockSysctlProvider = MockSysctlProvider()
        mockObserver = MockLibraryDataObserver()
        library = KernelHardwareLibrary(observer: mockObserver, sysctlProvider: mockSysctlProvider)
    }
    
    override func tearDown() {
        library.stop()
        LibraryManager.shared.resetForTesting() // Reset the LibraryManager
        mockObserver = nil
        mockSysctlProvider = nil
        library = nil
        super.tearDown()
    }
    
    func testStart_ShouldFetchCorrectInitialData() {
        // Given: Configure the mock to return specific values
        mockSysctlProvider.sysctlReturnValue = 0
        mockSysctlProvider.sysctlType = CPUType.ARM64
        mockSysctlProvider.sysctlMemorySize = 16 * 1024 * 1024 * 1024 // 16 GB
        mockSysctlProvider.sysctlKernelVersion = "20.6.0"
        mockSysctlProvider.sysctlCPUCores = 6
        mockSysctlProvider.sysctlPhysicalCores = 6
        mockSysctlProvider.sysctlLogicalCores = 6
        mockSysctlProvider.sysctlKernelSecureLevel = 0
        mockSysctlProvider.sysctlMemoryTaggingEncryption = 0
        mockSysctlProvider.sysctlPointerAuthentication = 0
        mockSysctlProvider.sysctlPageSize = 16384
        mockSysctlProvider.sysctlSocketBufferSize = 6291456
        mockSysctlProvider.sysctlMaxOpenFiles = 10
        mockSysctlProvider.sysctlKernelName = "Darwin"
        mockSysctlProvider.sysctlOSVersion = "22A354"
        mockSysctlProvider.sysctlKernelModel = "22A354"
        mockSysctlProvider.sysctlHostname = "localhost"
        mockSysctlProvider.sysctlCPUFrequency = 3500000000
        mockSysctlProvider.sysctlMaxCPUFrequency = 4000000000
        mockSysctlProvider.sysctlMinCPUFrequency = 3200000000
        mockSysctlProvider.sysctlMaxBatteryCapacity = 4323
        mockSysctlProvider.sysctlCurrentBattery = 3243
        mockSysctlProvider.sysctlMaxFileSize = 4294967296
        mockSysctlProvider.sysctlL1CacheSize = 4294967
        mockSysctlProvider.sysctlL2CacheSize = 4194304
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .kernelHardware)
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "ARM64")
        XCTAssertEqual(mockObserver.updatedData?["Kernel Version"], "20.6.0")
        XCTAssertEqual(mockObserver.updatedData?["Amount of RAM"], "16.0 GB")
        XCTAssertEqual(mockObserver.updatedData?["Kernel Name"], "Darwin")
        XCTAssertEqual(mockObserver.updatedData?["Number of Processors"], "6")
        XCTAssertEqual(mockObserver.updatedData?["Number of Physical CPU Cores"], "6")
        XCTAssertEqual(mockObserver.updatedData?["Number of Logical CPU Cores"], "6")
        XCTAssertEqual(mockObserver.updatedData?["CPU Frequency"], "3500 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Maximum CPU Frequency"], "4000 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Minimum CPU Frequency"], "3200 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Memory Page Size"], "16384 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Pointer Authentication"], "Supported")
        XCTAssertEqual(mockObserver.updatedData?["Memory Tagging Encryption"], "Supported")
        XCTAssertEqual(mockObserver.updatedData?["Current Battery Capacity"], "3243 mAh")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Power Capacity"], "4323 mAh")
        XCTAssertEqual(mockObserver.updatedData?["Device Hostname"], "localhost")
        XCTAssertEqual(mockObserver.updatedData?["Device Model"], "22A354")
        XCTAssertEqual(mockObserver.updatedData?["Operating System Version"], "22A354")
        XCTAssertEqual(mockObserver.updatedData?["Host Security Level ID"], "0")
        XCTAssertEqual(mockObserver.updatedData?["L1 Cache Size of the CPU"], "4294967 bytes")
        XCTAssertEqual(mockObserver.updatedData?["L2 Cache Size of the CPU"], "4194304 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Buffer Size for Network Sockets"], "6291456 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum File Size"], "4294967296 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Number of Open File"], "10")
    }
    
    func testStart_ShouldReturnFailedData() {
        // Given: Configure the mock to return -1 (unknown or 0)
        mockSysctlProvider.sysctlReturnValue = -1
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Assert that the observer received the correct data
        XCTAssertEqual(mockObserver.updatedLibraryType, .kernelHardware)
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Kernel Version"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Amount of RAM"], "0 GB")
        XCTAssertEqual(mockObserver.updatedData?["Kernel Name"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Number of Processors"], "0")
        XCTAssertEqual(mockObserver.updatedData?["Number of Physical CPU Cores"], "0")
        XCTAssertEqual(mockObserver.updatedData?["Number of Logical CPU Cores"], "0")
        XCTAssertEqual(mockObserver.updatedData?["CPU Frequency"], "0 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Maximum CPU Frequency"], "0 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Minimum CPU Frequency"], "0 MHz")
        XCTAssertEqual(mockObserver.updatedData?["Memory Page Size"], "0 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Pointer Authentication"], "Not Supported")
        XCTAssertEqual(mockObserver.updatedData?["Memory Tagging Encryption"], "Not Supported")
        XCTAssertEqual(mockObserver.updatedData?["Current Battery Capacity"], "0 mAh")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Power Capacity"], "0 mAh")
        XCTAssertEqual(mockObserver.updatedData?["Device Hostname"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Device Model"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Operating System Version"], "Unknown")
        XCTAssertEqual(mockObserver.updatedData?["Host Security Level ID"], "0")
        XCTAssertEqual(mockObserver.updatedData?["L1 Cache Size of the CPU"], "0 bytes")
        XCTAssertEqual(mockObserver.updatedData?["L2 Cache Size of the CPU"], "0 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Buffer Size for Network Sockets"], "0 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum File Size"], "0 bytes")
        XCTAssertEqual(mockObserver.updatedData?["Maximum Number of Open File"], "0")
    }
    
    func testStart_ShouldGetARM() {
        // Given: configure CPU type for ARM
        mockSysctlProvider.sysctlReturnValue = 0
        mockSysctlProvider.sysctlType = CPUType.ARM
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Then:
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "ARM")
    }
    
    func testStart_ShouldGetx86_64() {
        // Given: configure CPU type for x86_64
        mockSysctlProvider.sysctlReturnValue = 0
        mockSysctlProvider.sysctlType = CPUType.X86_64
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Then
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "x86_64")
    }
    
    func testStart_ShouldGetx86() {
        // Given: configure CPU type for x86
        mockSysctlProvider.sysctlReturnValue = 0
        mockSysctlProvider.sysctlType = CPUType.X86
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Then
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "x86")
    }
    
    func testStart_ShouldReturnUnknownOnSucess() {
        // Given: configure CPU type for x86
        mockSysctlProvider.sysctlReturnValue = 0
        mockSysctlProvider.sysctlType = CPUType.Unknown
        
        // Create an expectation to wait for the async data fetch
        let expectation = self.expectation(description: "Waiting for data fetch")
        
        // Set the observer's callback to fulfill the expectation when data is received
        mockObserver.addUpdateCallback {
            expectation.fulfill()
        }
        
        // When: Start the library
        library.start()
        
        // Then: Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
        
        // Then
        XCTAssertEqual(mockObserver.updatedData?["CPU Type"], "Unknown")
    }
    
    func testStop_ShouldNotCrash() {
        // Given
        library.start()
        
        // When
        library.stop()
        
        // Then
        XCTAssertTrue(true)
    }
}
