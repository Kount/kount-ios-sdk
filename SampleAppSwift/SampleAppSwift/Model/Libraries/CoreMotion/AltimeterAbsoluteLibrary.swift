//
//  AltimeterAbsoluteLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

protocol AltimeterAbsoluteProtocol {
    func startAbsoluteAltitudeUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAbsoluteAltitudeHandler)
    func stopAbsoluteAltitudeUpdates()
}

protocol AltimeterAbsoluteAvailabilityProtocol {
    static func isAbsoluteAltitudeAvailable() -> Bool
}

extension CMAltimeter: AltimeterAbsoluteProtocol, AltimeterAbsoluteAvailabilityProtocol {}

final class AltimeterAbsoluteLibrary: Library {
    private let altimeter: AltimeterAbsoluteProtocol
    private let altimeterAvailability: AltimeterAbsoluteAvailabilityProtocol.Type
    private weak var observer: LibraryDataObserver?
    
    var type: LibraryType { return .altimeterAbsolute }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Altitude", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Accuracy", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Precision", requiresLiveUpdates: true, value: "...")
    ]
    
    init(observer: LibraryDataObserver, altimeter: AltimeterAbsoluteProtocol = CMAltimeter(), altimeterAvailability: AltimeterAbsoluteAvailabilityProtocol.Type = CMAltimeter.self) {
        self.observer = observer
        self.altimeter = altimeter
        self.altimeterAvailability = altimeterAvailability
    }
    
    func start() {
        guard altimeterAvailability.isAbsoluteAltitudeAvailable() else { return }
        altimeter.startAbsoluteAltitudeUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, error == nil, let data = data else { return }
            self.updateParameters(data)
        }
    }
    
    func stop() {
        altimeter.stopAbsoluteAltitudeUpdates()
    }
    
    private func updateParameters(_ data: CMAbsoluteAltitudeData) {
        parameters[0].value = String(format: "%.2f m", data.altitude)
        parameters[1].value = String(format: "%.2f m", data.accuracy)
        parameters[2].value = String(format: "%.2f m", data.precision)
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
