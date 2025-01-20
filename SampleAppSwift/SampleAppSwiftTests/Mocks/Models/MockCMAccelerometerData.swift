//
//  MockCMAccelerometerData.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import CoreMotion

class MockCMAccelerometerData: CMAccelerometerData {
    var mockAcceleration: CMAcceleration
    
    init(acceleration: CMAcceleration) {
        self.mockAcceleration = acceleration
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceleration: CMAcceleration {
        return mockAcceleration
    }
}
