//
//  MockMotionManager.swift
//  SampleAppSwiftTests
//
//  Created by Alejandro Villalobos on 05-07-24.
//

import CoreMotion
@testable import SampleAppSwift

class MockAccelerometerManager: AccelerometerManagerProtocol {
    var isAccelerometerAvailable: Bool = true
    var accelerometerUpdateInterval: TimeInterval = 0.5
    var startUpdatesHandler: ((CMAccelerometerData?, Error?) -> Void)?
    
    func startAccelerometerUpdates(to queue: OperationQueue, withHandler handler: @escaping CMAccelerometerHandler) {
        startUpdatesHandler = handler
    }
    
    func stopAccelerometerUpdates() {}
}
