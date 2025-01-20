//
//  AltimeterRelativeLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

import CoreMotion

protocol AltimeterRelativeProtocol {
    func startRelativeAltitudeUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAltitudeHandler)
    func stopRelativeAltitudeUpdates()
}

protocol AltimeterRelativeAvailabilityProtocol {
    static func isRelativeAltitudeAvailable() -> Bool
}

extension CMAltimeter: AltimeterRelativeProtocol, AltimeterRelativeAvailabilityProtocol {}

final class AltimeterRelativeLibrary: Library {
    private let altimeter: AltimeterRelativeProtocol
    private let altimeterAvailability: AltimeterRelativeAvailabilityProtocol.Type
    private weak var observer: LibraryDataObserver?
    
    var type: LibraryType { return .altimeterRelative }
    var parameters: [LibraryParameter] = [
        LibraryParameter(name: "Pressure", requiresLiveUpdates: true, value: "..."),
        LibraryParameter(name: "Altitude", requiresLiveUpdates: true, value: "...")
    ]
    
    init(observer: LibraryDataObserver, altimeter: AltimeterRelativeProtocol = CMAltimeter(), altimeterAvailability: AltimeterRelativeAvailabilityProtocol.Type = CMAltimeter.self) {
        self.observer = observer
        self.altimeter = altimeter
        self.altimeterAvailability = altimeterAvailability
    }
    
    func start() {
        guard altimeterAvailability.isRelativeAltitudeAvailable() else { return }
        altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, error == nil, let data = data else { return }
            self.updateParameters(data)
        }
    }
    
    func stop() {
        altimeter.stopRelativeAltitudeUpdates()
    }
    
    private func updateParameters(_ data: CMAltitudeData) {
        parameters[0].value = String(format: "%.2f hPa", data.pressure.doubleValue)
        parameters[1].value = String(format: "%.2f m", data.relativeAltitude.doubleValue)
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
