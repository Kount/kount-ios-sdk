//
//  DeviceInfoLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 19-08-24.
//

import UIKit

protocol DeviceProtocol {
    var orientation: UIDeviceOrientation { get }
    var batteryState: UIDevice.BatteryState { get }
    var batteryLevel: Float { get }
    var name: String { get }
    var systemName: String { get }
    var systemVersion: String { get }
    var model: String { get }
    var isBatteryMonitoringEnabled: Bool { get set }
}

extension UIDevice: DeviceProtocol {}

class DeviceInfoLibrary: Library {
    private weak var observer: LibraryDataObserver?
    private var device: DeviceProtocol
    private var orientationObserver: NSObjectProtocol?
    private var batteryStateObserver: NSObjectProtocol?
    private var batteryLevelObserver: NSObjectProtocol?
    
    var type: LibraryType { return .deviceInfo }
    var parameters: [LibraryParameter] = []
    
    init(observer: LibraryDataObserver, device: DeviceProtocol = UIDevice.current) {
        self.observer = observer
        self.device = device
        self.parameters = [
            LibraryParameter(name: "Device Name", requiresLiveUpdates: false, value: device.name),
            LibraryParameter(name: "System Name", requiresLiveUpdates: false, value: device.systemName),
            LibraryParameter(name: "System Version", requiresLiveUpdates: false, value: device.systemVersion),
            LibraryParameter(name: "Model", requiresLiveUpdates: false, value: device.model),
            LibraryParameter(name: "Orientation", requiresLiveUpdates: true, value: UIDevice.orientationDescription(device.orientation)),
            LibraryParameter(name: "Battery State", requiresLiveUpdates: true, value: UIDevice.batteryStateDescription(device.batteryState)),
            LibraryParameter(name: "Battery Level", requiresLiveUpdates: true, value: device.batteryLevel >= 0 ? "\(Int(device.batteryLevel * 100))%" : "Unknown")
        ]
    }
    
    func start() {
        device.isBatteryMonitoringEnabled = true
        
        // Add observers
        orientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateOrientation()
        }
        
        batteryStateObserver = NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateBatteryState()
        }
        
        batteryLevelObserver = NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateBatteryLevel()
        }
        
        // Fetch initial data
        fetchInitialData()
    }
    
    func stop() {
        // Remove observers
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver)
            self.orientationObserver = nil
        }
        if let batteryStateObserver = batteryStateObserver {
            NotificationCenter.default.removeObserver(batteryStateObserver)
            self.batteryStateObserver = nil
        }
        if let batteryLevelObserver = batteryLevelObserver {
            NotificationCenter.default.removeObserver(batteryLevelObserver)
            self.batteryLevelObserver = nil
        }
        
        device.isBatteryMonitoringEnabled = false
    }
    
    private func updateOrientation() {
        if let index = parameters.firstIndex(where: { $0.name == "Orientation" }) {
            parameters[index].value = UIDevice.orientationDescription(device.orientation)
            notifyObserver()
        }
    }
    
    private func updateBatteryState() {
        if let index = parameters.firstIndex(where: { $0.name == "Battery State" }) {
            parameters[index].value = UIDevice.batteryStateDescription(device.batteryState)
            notifyObserver()
        }
    }
    
    private func updateBatteryLevel() {
        if let index = parameters.firstIndex(where: { $0.name == "Battery Level" }) {
            parameters[index].value = device.batteryLevel >= 0 ? "\(Int(device.batteryLevel * 100))%" : "Unknown"
            notifyObserver()
        }
    }
    
    private func fetchInitialData() {
        notifyObserver()
    }
    
    private func notifyObserver() {
        guard let observer = observer else { return }
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        observer.didUpdateLibraryData(data, for: type)
    }
}
