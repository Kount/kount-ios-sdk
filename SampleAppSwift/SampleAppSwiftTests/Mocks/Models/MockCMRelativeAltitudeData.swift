//
//  MockCMAltitudeRelativeData.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 08-07-24.
//

import CoreMotion

class MockCMRelativeAltitudeData: CMAltitudeData {
    var mockPressure: NSNumber
    var mockRelativeAltitude: NSNumber
    
    init(pressure: Double, relativeAltitude: Double) {
        self.mockPressure = NSNumber(value: pressure)
        self.mockRelativeAltitude = NSNumber(value: relativeAltitude)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var pressure: NSNumber {
        return mockPressure
    }
    
    override var relativeAltitude: NSNumber {
        return mockRelativeAltitude
    }
}
