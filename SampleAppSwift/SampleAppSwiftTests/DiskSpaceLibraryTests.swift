//
//  DiskSpaceLibraryTests.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 27-08-24.
//

import XCTest
@testable import SampleAppSwift

final class DiskSpaceLibraryTests: XCTestCase {
    
    var mockFileManager: MockFileManager!
    var mockObserver: MockLibraryDataObserver!
    var library: DiskSpaceLibrary!
    
    override func setUp() {
        super.setUp()
        mockFileManager = MockFileManager()
        mockObserver = MockLibraryDataObserver()
        library = DiskSpaceLibrary(observer: mockObserver, fileManager: mockFileManager)
    }
    
    func testGetTotalDiskSpace_Success() {
        // Given
        let totalSpace: Int64 = 128_000_000_000 // 128 GB
        mockFileManager.mockAttributes = [.systemSize: NSNumber(value: totalSpace)]
        
        // When
        let totalDiskSpace = library.getTotalDiskSpace()
        
        // Then
        XCTAssertEqual(totalDiskSpace, ByteCountFormatter.string(fromByteCount: totalSpace, countStyle: .file))
    }
    
    func testGetAvailableDiskSpace_Success() {
        // Given
        let availableSpace: Int64 = 64_000_000_000 // 64 GB
        mockFileManager.mockAttributes = [.systemFreeSize: NSNumber(value: availableSpace)]
        
        // When
        let availableDiskSpace = library.getAvailableDiskSpace()
        
        // Then
        XCTAssertEqual(availableDiskSpace, ByteCountFormatter.string(fromByteCount: availableSpace, countStyle: .file))
    }
    
    func testGetUsedDiskSpace_Success() {
        // Given
        let totalSpace: Int64 = 128_000_000_000 // 128 GB
        let availableSpace: Int64 = 64_000_000_000 // 64 GB
        mockFileManager.mockAttributes = [
            .systemSize: NSNumber(value: totalSpace),
            .systemFreeSize: NSNumber(value: availableSpace)
        ]
        
        // When
        let usedDiskSpace = library.getUsedDiskSpace()
        let calculatedUsedSpace = totalSpace - availableSpace
        
        // Then
        XCTAssertEqual(usedDiskSpace, ByteCountFormatter.string(fromByteCount: calculatedUsedSpace, countStyle: .file))
    }
    
    func testDiskSpaceRetrievalError() {
        // Given
        mockFileManager.shouldThrowError = true
        
        // When
        let totalDiskSpace = library.getTotalDiskSpace()
        let availableDiskSpace = library.getAvailableDiskSpace()
        let usedDiskSpace = library.getUsedDiskSpace()
        
        // Then
        XCTAssertNil(totalDiskSpace)
        XCTAssertNil(availableDiskSpace)
        XCTAssertNil(usedDiskSpace)
    }
    
    func testFetchLibraryData() {
        // Given
        let totalSpace: Int64 = 128_000_000_000 // 128 GB
        let availableSpace: Int64 = 64_000_000_000 // 64 GB
        mockFileManager.mockAttributes = [
            .systemSize: NSNumber(value: totalSpace),
            .systemFreeSize: NSNumber(value: availableSpace)
        ]
        
        // Initialize the library again with the mock data.
        library = DiskSpaceLibrary(observer: mockObserver, fileManager: mockFileManager)
        
        // When
        library.start()
        
        // Then
        let fetchedData = mockObserver.updatedData
        let usedSpace = totalSpace - availableSpace
        
        XCTAssertEqual(fetchedData?["Total Disk Space"], ByteCountFormatter.string(fromByteCount: totalSpace, countStyle: .file))
        XCTAssertEqual(fetchedData?["Available Disk Space"], ByteCountFormatter.string(fromByteCount: availableSpace, countStyle: .file))
        XCTAssertEqual(fetchedData?["Used Disk Space"], ByteCountFormatter.string(fromByteCount: usedSpace, countStyle: .file))
    }
    
    func testStart_CallsObserver() {
        // Given
        let totalSpace: Int64 = 128_000_000_000 // 128 GB
        let availableSpace: Int64 = 64_000_000_000 // 64 GB
        mockFileManager.mockAttributes = [
            .systemSize: NSNumber(value: totalSpace),
            .systemFreeSize: NSNumber(value: availableSpace)
        ]
        
        // Initialize the library again with the mock data.
        library = DiskSpaceLibrary(observer: mockObserver, fileManager: mockFileManager)
        
        // When
        library.start()
        
        // Then
        XCTAssertNotNil(mockObserver.updatedData)
        XCTAssertEqual(mockObserver.updatedLibraryType, .diskSpace)
    }
    
    func testStop_DoesNothing() {
        // Just testing that calling stop doesn't crash or do anything unexpected
        library.stop()
    }
}
