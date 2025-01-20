//
//  SelectorViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import UIKit

class SelectorViewController: UIViewController {
    //MARK: Oulets
    @IBOutlet weak var sensorConfigLabel: UILabel!
    @IBOutlet weak var accelerometerLabel: UILabel!
    @IBOutlet weak var gyroLabel: UILabel!
    @IBOutlet weak var magnetometerLabel: UILabel!
    @IBOutlet weak var deviceMotionLabel: UILabel!
    @IBOutlet weak var pedometerLabel: UILabel!
    @IBOutlet weak var motionActivityLabel: UILabel!
    @IBOutlet weak var accelerometerSwitch: UISwitch!
    @IBOutlet weak var gyroSwitch: UISwitch!
    @IBOutlet weak var magnetometerSwitch: UISwitch!
    @IBOutlet weak var deviceMotionSwitch: UISwitch!
    @IBOutlet weak var pedometerSwitch: UISwitch!
    @IBOutlet weak var motionActivitySwitch: UISwitch!
    @IBOutlet weak var button: UIButton!
    
    var viewModel: SelectorViewModel!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SelectorViewController - viewDidLoad")
        viewModel = SelectorViewModel()
        loadViews()
    }
    
    //MARK: Functions
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadViews() {
        // Set Navigation Bar
        navigationItem.title = NSLocalizedString("core_motion_title", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("back_button", comment: ""), style: .done, target: self, action: #selector(dismissViewController))
        
        // Set text in the UI
        sensorConfigLabel.text = NSLocalizedString("core_motion_configuration", comment: "")
        accelerometerLabel.text = NSLocalizedString("accelerometer_title", comment: "")
        gyroLabel.text = NSLocalizedString("gyro_title", comment: "")
        magnetometerLabel.text = NSLocalizedString("magnetometer_title", comment: "")
        deviceMotionLabel.text = NSLocalizedString("device_motion_title", comment: "")
        pedometerLabel.text = NSLocalizedString("pedometer_title", comment: "")
    }
    
    private func checkActivatedSensors() {
        if accelerometerSwitch.isOn {
            SensorManager.shared.startAccelerometer()
        }
        
        if gyroSwitch.isOn {
            SensorManager.shared.startGyroscope()
        }
        
        if magnetometerSwitch.isOn {
            SensorManager.shared.startMagnetometer()
        }
        
        if deviceMotionSwitch.isOn {
            SensorManager.shared.startDeviceMotion()
        }
        
        if pedometerSwitch.isOn {
            SensorManager.shared.startPedometer()
        }
        
        if deviceMotionSwitch.isOn {
            SensorManager.shared.startMotionActivity()
        }
    }
    
    private func checkSwitchStatus() -> Bool {
        accelerometerSwitch.isOn || gyroSwitch.isOn || magnetometerSwitch.isOn || deviceMotionSwitch.isOn || pedometerSwitch.isOn || motionActivitySwitch.isOn
    }
    
    // MARK: Actions
    @IBAction func startButton(_ sender: Any) {
        if checkSwitchStatus() {
            performSegue(withIdentifier: "goToCoreMotionData", sender: self)
        }
    }
    
    // MARK: Navigation and Segue handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCoreMotionData" {
            if let vc = segue.destination as? DataViewController {
                vc.accelerometerSwitch = accelerometerSwitch.isOn
                vc.gyroSwitch = gyroSwitch.isOn
                vc.magnetometerSwitch = magnetometerSwitch.isOn
                vc.deviceMotionSwitch = deviceMotionSwitch.isOn
                vc.pedometerSwitch = pedometerSwitch.isOn
                vc.motionActivitySwitch = motionActivitySwitch.isOn
                checkActivatedSensors()
            }
        }
    }
}
