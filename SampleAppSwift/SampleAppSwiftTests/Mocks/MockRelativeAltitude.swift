//
//  MockRelativeAltitude.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 08-07-24.
//

import CoreMotion
@testable import SampleAppSwift

class MockRelativeAltitude: AltimeterRelativeProtocol, AltimeterRelativeAvailabilityProtocol {
    static var isAvailable: Bool = true
    
    class func isRelativeAltitudeAvailable() -> Bool {
        return isAvailable
    }
    
    var startRelativeUpdatesHandler: ((CMAltitudeData?, Error?) -> Void)?
    
    func startRelativeAltitudeUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAltitudeHandler) {
        startRelativeUpdatesHandler = handler
    }
    
    func stopRelativeAltitudeUpdates() {}
}
