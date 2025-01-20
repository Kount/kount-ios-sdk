//
//  LogViewModel.swift.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 21-03-24.
//

import CoreMotion

class LogViewModel: SensorDataObserver {
    
    var onNewData: (() -> Void)?
    var sensorsPaused: Bool = false
    
    
    init() {
        SensorManager.shared.onLogUpdated = { [weak self] _ in
            self?.onNewData?()
        }
        SensorManager.shared.addObserver(self)
    }
    
    deinit {
        SensorManager.shared.removeObserver(self)
    }
    
    func didUpdateAccelerometerData(_ data: CMAccelerometerData) {
        let entry = "Accelerometer - x: \(data.acceleration.x), y: \(data.acceleration.y), z: \(data.acceleration.z) "
        onNewData?()
    }
    
    func didUpdateGyroscopeData(_ data: CMGyroData) {
        let entry = "Gyroscope - x: \(data.rotationRate.x), y: \(data.rotationRate.y), z: \(data.rotationRate.z) "
        onNewData?()
    }
    
    func didUpdateMagnetometerData(_ data: CMMagnetometerData) {
        let entry = "Magnetometer - x: \(data.magneticField.x), y: \(data.magneticField.y), z: \(data.magneticField.z) "
        onNewData?()
    }
    
    func didUpdateDeviceMotionData(_ data: CMDeviceMotion) {
        let entry = "DeviceMotionData - yaw: \(data.attitude.yaw), roll: \(data.attitude.roll), pitch: \(data.attitude.pitch)\nDeviceMotionData - x: \(data.gravity.x), y: \(data.gravity.y), z: \(data.gravity.z)"
        onNewData?()
    }
    
    func didUpdatePedometerData(_ data: CMPedometerData) {
        let entry = "Pedometer - numberOfSteps: \(data.numberOfSteps)"
        onNewData?()
    }
    
    func didUpdateMotionActivityData(_ data: CMMotionActivity) {
        let entry = "MotionActivity - determineActivityState: \(data.description)"
        onNewData?()
    }
        
    func toggleSensors() {
        if sensorsPaused {
            SensorManager.shared.stopAllEnabledSensors()
        } else {
            SensorManager.shared.startAllEnabledSensors()
        }
        sensorsPaused.toggle()
    }
}
