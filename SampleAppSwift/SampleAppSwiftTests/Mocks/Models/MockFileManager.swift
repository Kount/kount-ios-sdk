//
//  MockFileManager.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 27-08-24.
//

import Foundation

class MockFileManager: FileManager {
    var mockAttributes: [FileAttributeKey: NSNumber] = [:]
    var shouldThrowError = false
    
    override func attributesOfFileSystem(forPath path: String) throws -> [FileAttributeKey : Any] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return mockAttributes
    }
}
