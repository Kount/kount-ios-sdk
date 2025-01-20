//
//  PedometerLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

final class PedometerLibrary: Library {
    private let pedometer = CMPedometer()
    private weak var observer: LibraryDataObserver?

    var type: LibraryType { return .pedometer }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Steps", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Average active pace", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Distance", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Floors ascended", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Floors descended", requiresLiveUpdates: true, value: "...")
    ]

    init(observer: LibraryDataObserver) {
        self.observer = observer
    }

    func start() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        pedometer.startUpdates(from: Date()) { [weak self] (pedometerData, error) in
            guard let self = self, error == nil, let data = pedometerData else { return }
            updateParameters(data)
        }
    }

    func stop() {
        pedometer.stopUpdates()
    }
    
    private func updateParameters(_ data: CMPedometerData) {
        parameters[0].value = String(describing: data.numberOfSteps)
        parameters[1].value = String(format: "%.2f m/s", data.averageActivePace?.doubleValue ?? 0.0)
        parameters[2].value = String(format: "%.2f m", data.distance?.doubleValue ?? 0.0)
        parameters[3].value = String(format: "%.2f floors", data.floorsAscended?.intValue ?? 0)
        parameters[4].value = String(format: "%.2f floors", data.floorsDescended?.intValue ?? 0)
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
