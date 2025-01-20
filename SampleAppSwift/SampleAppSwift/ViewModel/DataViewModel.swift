//
//  DataViewModel.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import CoreMotion

class DataViewModel: SensorDataObserver {
    
    var accelerometerSensorUpdated: ((CMAccelerometerData) -> Void)?
    var gyroscopeSensorUpdated: ((CMGyroData) -> Void)?
    var magnetometerSensorUpdated: ((CMMagnetometerData) -> Void)?
    var deviceMotionSensorUpdated: ((CMDeviceMotion) -> Void)?
    var pedometerSensorUpdated: ((CMPedometerData) -> Void)?
    var motionControlSensorUpdated: ((CMMotionActivity) -> Void)?
    private var sensorsPaused = false
    
    
    init() {
        SensorManager.shared.addObserver(self)
    }
    
    deinit {
        SensorManager.shared.removeObserver(self)
    }
    
    func didUpdateAccelerometerData(_ data: CMAccelerometerData) {
       accelerometerSensorUpdated?(data)
    }
    
    func didUpdateGyroscopeData(_ data: CMGyroData) {
        gyroscopeSensorUpdated?(data)
    }
    
    func didUpdateMagnetometerData(_ data: CMMagnetometerData) {
        magnetometerSensorUpdated?(data)
    }
    
    func didUpdateDeviceMotionData(_ data: CMDeviceMotion){
        deviceMotionSensorUpdated?(data)
    }
    
    func didUpdatePedometerData(_ data: CMPedometerData){
        pedometerSensorUpdated?(data)
    }
    
    func didUpdateMotionActivityData(_ data: CMMotionActivity) {
        motionControlSensorUpdated?(data)
    }
    
    func determineActivityState(activity: CMMotionActivity) -> String {
        if activity.walking {
            return ActivityState.walking.rawValue
        } else if activity.running {
            return ActivityState.running.rawValue
        } else if activity.automotive {
            return ActivityState.automotive.rawValue
        } else if activity.cycling {
            return ActivityState.cycling.rawValue
        } else if activity.stationary {
            return ActivityState.stationary.rawValue
        } else {
            return ActivityState.unknown.rawValue
        }
    }
    
    func toggleSensors() {
        sensorsPaused ? SensorManager.shared.startAllEnabledSensors() : SensorManager.shared.stopAllEnabledSensors()
        sensorsPaused.toggle()
    }
    
    func getAccelerometerPosition(_ acceleration: CMAcceleration) -> String {
        let horizontalThreshold: Double = 0.95
        let tiltThreshold: Double = 0.5
        
        if acceleration.z < -horizontalThreshold || acceleration.z > horizontalThreshold {
            return AccelerometerPosition.horizontal.rawValue
        } else if acceleration.y < -horizontalThreshold || acceleration.y > horizontalThreshold {
            return AccelerometerPosition.vertical.rawValue
        } else if acceleration.z < -tiltThreshold && acceleration.y < -tiltThreshold {
            return AccelerometerPosition.tilted.rawValue
        } else {
            return AccelerometerPosition.landscape.rawValue
        }
    }
    
    func getGyrometerPosition(_ rotationRate: CMRotationRate) -> String {
        let movementThreshold: Double = 1
        
        if abs(rotationRate.x) > movementThreshold || abs(rotationRate.y) > movementThreshold || abs(rotationRate.z) > movementThreshold {
            return GyrometerPosition.rotating.rawValue
        } else {
            return GyrometerPosition.still.rawValue
        }
    }
}
