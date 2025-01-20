//
//  MagnetometerLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

final class MagnetometerLibrary: Library {
    private let motionManager = CMMotionManager()
    private weak var observer: LibraryDataObserver?
    
    var type: LibraryType { return .magnetometer }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "X axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Y axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Z axis", requiresLiveUpdates: true, value: "...")
    ]

    init(observer: LibraryDataObserver) {
        self.observer = observer
    }

    func start() {
        guard motionManager.isMagnetometerAvailable else { return }
        motionManager.magnetometerUpdateInterval = 0.5
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] (magnetometerData, error) in
            guard let self = self, error == nil, let data = magnetometerData else { return }
            updateParameters(data)
        }
    }

    func stop() {
        motionManager.stopMagnetometerUpdates()
    }
    
    private func updateParameters(_ data: CMMagnetometerData) {
        parameters[0].value = String(format: "%.2f µT", data.magneticField.x)
        parameters[1].value = String(format: "%.2f µT", data.magneticField.y)
        parameters[2].value = String(format: "%.2f µT", data.magneticField.z)
        observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
    }
    
    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        return data
    }
}
