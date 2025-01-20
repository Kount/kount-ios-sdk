//
//  LibraryManager.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 25-03-24.
//

class LibraryManager {
    static let shared = LibraryManager()
    private var libraries: [LibraryType: Library] = [:]
    private var observers = [WeakLibraryDataObserver]()
    private let stateController = LibraryStateController()
    
    private init() {}
    
    func addObserver(_ observer: LibraryDataObserver) {
        observers = observers.filter { $0.reference != nil }
        observers.append(WeakLibraryDataObserver(reference: observer))
    }
    
    func removeObserver(_ observer: LibraryDataObserver) {
        observers.removeAll { $0.reference === observer }
    }
    
    func enableLibraries(_ libraries: [LibraryType]) {
        libraries.forEach { shouldEnableLibrary(true, for: $0) }
    }
    
    func shouldEnableLibrary(_ isEnabled: Bool, for type: LibraryType) {
        stateController.setLibraryEnabled(isEnabled, for: type)
        if isEnabled {
            let library = LibraryFactory.createLibrary(for: type, observer: self)
            libraries[type] = library
            library.start()
        } else {
            libraries[type]?.stop()
            libraries.removeValue(forKey: type)
        }
    }
    
    func isLibraryEnabled(for type: LibraryType) -> Bool {
        return stateController.isLibraryEnable(for: type)
    }
    
    func startAllEnabledLibraries() {
        LibraryType.allCases.forEach { libraryType in
            if isLibraryEnabled(for: libraryType) {
                libraries[libraryType]?.start()
            }
        }
    }
    
    func stopAllEnabledLibraries() {
        LibraryType.allCases.forEach { libraryType in
            libraries[libraryType]?.stop()
        }
    }
    
#if DEBUG
    // Add this method for testing purposes
    func resetForTesting() {
        stopAllEnabledLibraries()
        observers.removeAll()
    }
#endif
}

extension LibraryManager: LibraryDataObserver {
    func didUpdateLibraryData(_ data: [String: String], for libraryType: LibraryType) {
        observers.forEach { $0.reference?.didUpdateLibraryData(data, for: libraryType) }
    }
}

private class WeakLibraryDataObserver {
    weak var reference: LibraryDataObserver?
    
    init(reference: LibraryDataObserver? = nil) {
        self.reference = reference
    }
}
