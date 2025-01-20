//
//  MockCMAbsoluteAltitudeData.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import CoreMotion

class MockCMAbsoluteAltitudeData: CMAbsoluteAltitudeData {
    var mockAltitude: Double
    var mockAccuracy: Double
    var mockPrecision: Double
    
    init(altitude: Double, accuracy: Double, precision: Double) {
        self.mockAltitude = altitude
        self.mockAccuracy = accuracy
        self.mockPrecision = precision
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var altitude: Double {
        return mockAltitude
    }
    
    override var accuracy: Double {
        return mockAccuracy
    }
    
    override var precision: Double {
        return mockPrecision
    }
}
