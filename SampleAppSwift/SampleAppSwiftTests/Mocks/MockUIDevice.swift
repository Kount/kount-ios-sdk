//
//  MockUIDevice.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 21-08-24.
//

import UIKit
@testable import SampleAppSwift

class MockDevice: DeviceProtocol {
    var mockOrientation: UIDeviceOrientation = .portrait
    var mockBatteryState: UIDevice.BatteryState = .unknown
    var mockBatteryLevel: Float = -1.0
    
    var orientation: UIDeviceOrientation {
        return mockOrientation
    }
    
    var batteryState: UIDevice.BatteryState {
        return mockBatteryState
    }
    
    var batteryLevel: Float {
        return mockBatteryLevel
    }
    
    var name: String = "Mock Device"
    var systemName: String = "iOS"
    var systemVersion: String = "17.6.1"
    var model: String = "iPhone"
    
    var isBatteryMonitoringEnabled: Bool = false
}
