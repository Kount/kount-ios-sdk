//
//  ScreenBrightnessLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import UIKit

final class ScreenBrightnessLibrary: Library {
    private weak var observer: LibraryDataObserver?
    
    var type: LibraryType { return .screenBrightness }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Brightness", requiresLiveUpdates: true, value: String(format: "%.02f", UIScreen.main.brightness))
    ]
    
    init(observer: LibraryDataObserver) {
        self.observer = observer
    }
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenBrightnessDidChange), name: UIScreen.brightnessDidChangeNotification, object: nil)
        updateBrightness()
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self, name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    @objc private func screenBrightnessDidChange() {
        updateBrightness()
    }
    
    private func updateBrightness() {
        let brightness = String(format: "%.02f", UIScreen.main.brightness)
        updateParameters("Brightness", with: brightness)
    }
    
    private func updateParameters(_ name: String, with value: String) {
        if let index = parameters.firstIndex(where: { $0.name == name }) {
            parameters[index].value = value
            observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
        }
    }
    
    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        return data
    }
}
