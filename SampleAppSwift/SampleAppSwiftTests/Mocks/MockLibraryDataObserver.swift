//
//  MockLibraryDataObserver.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

@testable import SampleAppSwift

class MockLibraryDataObserver: LibraryDataObserver {
    var updatedData: [String: String]?
    var updatedLibraryType: LibraryType?
    private var updateCallbacks: [() -> Void] = []
    
    func didUpdateLibraryData(_ data: [String : String], for libraryType: LibraryType) {
        updatedData = data
        updatedLibraryType = libraryType
        updateCallbacks.forEach { $0() }
    }
    
    // Helper method to add a callback
    func addUpdateCallback(_ callback: @escaping () -> Void) {
        updateCallbacks.append(callback)
    }
    
    // Helper method to clear callbacks
    func clearUpdateCallbacks() {
        updateCallbacks.removeAll()
    }
}
