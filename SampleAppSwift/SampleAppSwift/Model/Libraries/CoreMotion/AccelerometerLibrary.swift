//
//  AccelerometerLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

protocol AccelerometerManagerProtocol: AccelerometerAvailabilityProtocol {
    var accelerometerUpdateInterval: TimeInterval { get set }
    func startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler)
    func stopAccelerometerUpdates()
}

protocol AccelerometerAvailabilityProtocol {
    var isAccelerometerAvailable: Bool { get }
}

extension CMMotionManager: AccelerometerManagerProtocol {}

final class AccelerometerLibrary: Library {
    private var motionManager: AccelerometerManagerProtocol
    private weak var observer: LibraryDataObserver?
    
    var type: LibraryType { return .accelerometer }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "X axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Y axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Z axis", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Position", requiresLiveUpdates: true, value: "...")
    ]
    
    init(observer: LibraryDataObserver, motionManager: AccelerometerManagerProtocol = CMMotionManager()) {
        self.observer = observer
        self.motionManager = motionManager
    }
    
    func start() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.5
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, error == nil, let data = data else { return }
            self.updateParameters(data)
        }
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
    
    private func updateParameters(_ data: CMAccelerometerData) {
        parameters[0].value = String(format: "%.2f m/s²", data.acceleration.x)
        parameters[1].value = String(format: "%.2f m/s²", data.acceleration.y)
        parameters[2].value = String(format: "%.2f m/s²", data.acceleration.z)
        parameters[3].value = getAccelerometerPosition(data.acceleration)
        observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
    }
    
    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        return data
    }
    
    internal func getAccelerometerPosition(_ acceleration: CMAcceleration) -> String {
        let horizontalThreshold: Double = 0.95
        let tiltThreshold: Double = 0.5
        
        if acceleration.z < -horizontalThreshold || acceleration.z > horizontalThreshold {
            return "Horizontal"
        } else if acceleration.y < -horizontalThreshold || acceleration.y > horizontalThreshold {
            return "Vertical"
        } else if acceleration.z < -tiltThreshold && acceleration.y < -tiltThreshold {
            return "Tilted"
        } else {
            return "Landscape"
        }
    }
}
