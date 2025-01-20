//
//  GyroscopeLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

final class GyroscopeLibrary: Library {
    private let motionManager = CMMotionManager()
    private weak var observer: LibraryDataObserver?

    var type: LibraryType { return .gyroscope }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "X axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Y axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Z axis", requiresLiveUpdates: true, value: "...")
    ]

    init(observer: LibraryDataObserver) {
        self.observer = observer
    }

    func start() {
        guard motionManager.isGyroAvailable else { return }
        motionManager.gyroUpdateInterval = 0.5
        motionManager.startGyroUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, error == nil, let data = data else { return }
            self.updateParameters(data)
        }
    }

    func stop() {
        motionManager.stopGyroUpdates()
    }
    
    private func updateParameters(_ data: CMGyroData) {
        parameters[0].value = String(format: "%.2f rad/s", data.rotationRate.x)
        parameters[1].value = String(format: "%.2f rad/s", data.rotationRate.y)
        parameters[2].value = String(format: "%.2f rad/s", data.rotationRate.z)
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
