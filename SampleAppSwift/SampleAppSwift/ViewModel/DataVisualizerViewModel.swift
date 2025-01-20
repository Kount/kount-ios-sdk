//
//  DataVisualizerViewModel.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import CoreMotion

class DataVisualizerViewModel {
    var libraryDataUpdated: ((LibraryType, [String: String]) -> Void)?
    private var isLibraryUpdating = false
    
    init(enabledLibraries: [LibraryType]) {
        LibraryManager.shared.addObserver(self)
        LibraryManager.shared.enableLibraries(enabledLibraries)
        LibraryManager.shared.startAllEnabledLibraries()
    }
    
    deinit {
        LibraryManager.shared.removeObserver(self)
    }
    
    func toggleLibraries() {
        if isLibraryUpdating {
            LibraryManager.shared.startAllEnabledLibraries()
        } else {
            LibraryManager.shared.stopAllEnabledLibraries()
        }
        isLibraryUpdating.toggle()
    }
}

extension DataVisualizerViewModel: LibraryDataObserver {
    func didUpdateLibraryData(_ data: [String: String], for libraryType: LibraryType) {
        libraryDataUpdated?(libraryType, data)
    }
}

protocol LibraryDataObserver: AnyObject {
    func didUpdateLibraryData(_ data: [String: String], for libraryType: LibraryType)
}
