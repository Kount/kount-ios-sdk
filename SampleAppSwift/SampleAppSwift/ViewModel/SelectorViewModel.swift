//
//  SelectorViewModel.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 21-03-24.
//

import CoreMotion

class SelectorViewModel {
    
    func toggleSensor(_ type: SensorType) {
        let isEnabled = SensorManager.shared.isSensorEnabled(for: type)
        SensorManager.shared.setSensorEnabled(!isEnabled, for: type)
    }
}
