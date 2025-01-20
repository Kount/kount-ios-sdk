//
//  DeviceMotionLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

final class DeviceMotionLibrary: Library {
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    private weak var observer: LibraryDataObserver?

    var type: LibraryType { return .deviceMotion }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Attitude - pitch(x)", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Attitude - roll(y)", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Attitude - yaw(z)", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Heading", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Gravity(x)", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Gravity(y)", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Gravity(z)", requiresLiveUpdates: true, value: "...")
    ]

    init(observer: LibraryDataObserver) {
        self.observer = observer
        self.motionQueue.name = "com.equifax.kount.sample.swift"
    }

    func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.5
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: motionQueue) { [weak self] (deviceMotion, error) in
            guard let self = self, error == nil, let motion = deviceMotion else { return }
            self.updateMotionData(motion)
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
    }

    private func updateMotionData(_ motion: CMDeviceMotion) {
        updateParameter("Attitude - pitch(x)", with: String(format: "%.2f°", motion.attitude.pitch * 180 / .pi))
        updateParameter("Attitude - roll(y)", with: String(format: "%.2f°", motion.attitude.roll * 180 / .pi))
        updateParameter("Attitude - yaw(z)", with: String(format: "%.2f°", motion.attitude.yaw * 180 / .pi))

        // Attempt to use motion.heading; fallback if needed
        let heading = motion.heading >= 0 ? motion.heading : calculateHeadingUsingMagnetometer(motion)
        updateParameter("Heading", with: String(format: "%.2f°", heading))

        updateParameter("Gravity(x)", with: String(format: "%.2f m/s²", motion.gravity.x))
        updateParameter("Gravity(y)", with: String(format: "%.2f m/s²", motion.gravity.y))
        updateParameter("Gravity(z)", with: String(format: "%.2f m/s²", motion.gravity.z))

        observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
    }

    private func calculateHeadingUsingMagnetometer(_ motion: CMDeviceMotion) -> Double {
        let magneticField = motion.magneticField.field
        let x = magneticField.x
        let y = magneticField.y

        let heading = atan2(y, x) * 180 / .pi // Calculate heading from the magnetic field
        return heading >= 0 ? heading : (heading + 360.0) // Normalize to 0-360°
    }

    private func updateParameter(_ name: String, with value: String) {
        if let index = parameters.firstIndex(where: { $0.name == name }) {
            parameters[index].value = value
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
