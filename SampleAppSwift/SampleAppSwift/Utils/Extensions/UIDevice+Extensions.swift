//
//  UIDevice+Extensions.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 22-08-24.
//

import UIKit

extension UIDevice {
    static func orientationDescription(_ orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .faceUp: return "Face Up"
        case .faceDown: return "Face Down"
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait Upside Down"
        case .landscapeLeft: return "Landscape Left"
        case .landscapeRight: return "Landscape Right"
        default: return "Unknown"
        }
    }
    
    static func batteryStateDescription(_ state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown: return "Unknown"
        case .unplugged: return "Unplugged"
        case .charging: return "Charging"
        case .full: return "Full"
        @unknown default:
            return "Unknown"
        }
    }
}
