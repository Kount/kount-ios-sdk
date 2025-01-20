//
//  MockAltimeter.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import CoreMotion
@testable import SampleAppSwift

class MockAbsoluteAltitude: AltimeterAbsoluteProtocol, AltimeterAbsoluteAvailabilityProtocol {
    static var isAvailable: Bool = true
    
    class func isAbsoluteAltitudeAvailable() -> Bool {
        return isAvailable
    }
    
    var startAbsoluteUpdatesHandler: ((CMAbsoluteAltitudeData?, Error?) -> Void)?
    
    func startAbsoluteAltitudeUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAbsoluteAltitudeHandler) {
        startAbsoluteUpdatesHandler = handler
    }
    
    func stopAbsoluteAltitudeUpdates() {}
}
