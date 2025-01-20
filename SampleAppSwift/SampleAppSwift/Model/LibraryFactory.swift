//
//  LibraryFactory.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

struct LibraryFactory {
    static func createLibrary(for type: LibraryType, observer: LibraryDataObserver) -> Library {
        switch type {
            // CoreMotion
        case .accelerometer:
            return AccelerometerLibrary(observer: observer)
        case .altimeterAbsolute:
            return AltimeterAbsoluteLibrary(observer: observer)
        case .altimeterRelative:
            return AltimeterRelativeLibrary(observer: observer)
        case .deviceMotion:
            return DeviceMotionLibrary(observer: observer)
        case .gyroscope:
            return GyroscopeLibrary(observer: observer)
        case .magnetometer:
            return MagnetometerLibrary(observer: observer)
        case .motionActivity:
            return MotionActivityLibrary(observer: observer)
        case .pedometer:
            return PedometerLibrary(observer: observer)
            
            // Darwin
        case .kernelHardware:
            return KernelHardwareLibrary(observer: observer)
            
            // System
        case .diskSpace:
            return DiskSpaceLibrary(observer: observer)
        
            // UIKit
        case .screenBrightness:
            return ScreenBrightnessLibrary(observer: observer)
        case .deviceInfo:
            return DeviceInfoLibrary(observer: observer)
        }
    }
}
