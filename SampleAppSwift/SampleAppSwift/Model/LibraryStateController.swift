//
//  LibraryStateController.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 26-03-24.
//

class LibraryStateController {
    private var libraryStates: [LibraryType: Bool] = [:]
    
    func setLibraryEnabled(_ isEnabled: Bool, for type: LibraryType) {
        libraryStates[type] = isEnabled
    }
    
    func isLibraryEnable(for type: LibraryType) -> Bool {
        return libraryStates[type] ?? false
    }
}
