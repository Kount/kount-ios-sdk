//
//  LibraryType.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 04-04-24.
//

import UIKit

enum LibraryType: String, CaseIterable {
    // CoreMotion
    case accelerometer, altimeterAbsolute, altimeterRelative, deviceMotion, gyroscope, magnetometer, motionActivity, pedometer
    
    // Darwin
    case kernelHardware
    
    // UIKit
    case screenBrightness, deviceInfo
    
    // System
    case diskSpace
    
    func formattedTitle() -> String {
        switch self {
            // CoreMotion
        case .accelerometer:
            return "Accelerometer"
        case .altimeterAbsolute:
            return "Altimeter - Absolute"
        case .altimeterRelative:
            return "Altimeter - Relative"
        case .deviceMotion:
            return "Device Motion"
        case .gyroscope:
            return "Gyroscope"
        case .magnetometer:
            return "Magnetometer"
        case .motionActivity:
            return "Motion Activity"
        case .pedometer:
            return "Pedometer"
            
            //Darwin
        case .kernelHardware:
            return "Kernel and Hardware"
            
            // System
        case .diskSpace:
            return "Disk Space"
            
            // UIKit
        case .screenBrightness:
            return "Screen Brightness"
        case .deviceInfo:
            return "Device Info"
        }
    }
    
    func orderedKeys() -> [String] {
        switch self {
            // CoreMotion
        case .accelerometer:
            return ["X axis", "Y axis", "Z axis", "Position"]
        case .altimeterAbsolute:
            return ["Altitude", "Accuracy", "Precision"]
        case .altimeterRelative:
            return ["Pressure", "Altitude"]
        case .deviceMotion:
            return ["Attitude - pitch(x)", "Attitude - roll(y)", "Attitude - yaw(z)", "Heading", "Gravity(x)", "Gravity(y)", "Gravity(z)"]
        case .gyroscope:
            return ["X axis", "Y axis", "Z axis"]
        case .magnetometer:
            return ["X axis", "Y axis", "Z axis"]
        case .motionActivity:
            return ["Current activity"]
        case .pedometer:
            return ["Steps", "Average active pace", "Distance", "Floors ascended", "Floors descended"]
            
            //Darwin
        case .kernelHardware:
            return ["CPU Type", "Number of Processors", "Number of Physical CPU Cores", "Number of Logical CPU Cores", "CPU Frequency", "Maximum CPU Frequency", "Minimum CPU Frequency", "Amount of RAM", "Memory Page Size", "Pointer Authentication", "Memory Tagging Encryption",  "Current Battery Capacity", "Maximum Power Capacity", "Device Hostname", "Device Model", "Kernel Name", "Kernel Version", "Operating System Version", "Host Security Level ID", "L1 Cache Size of the CPU", "L2 Cache Size of the CPU", "Maximum Buffer Size for Network Sockets", "Maximum File Size", "Maximum Number of Open File"]
            
            // System
        case .diskSpace:
            return ["Used Disk Space", "Available Disk Space", "Total Disk Space"]
            
            // UIKit
        case .screenBrightness:
            return ["Brightness"]
        case .deviceInfo:
            return ["Device Name", "System Name", "System Version", "Model", "Orientation", "Battery State", "Battery Level"]
        }
    }
}
