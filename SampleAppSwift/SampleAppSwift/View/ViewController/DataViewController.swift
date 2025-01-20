//
//  CoreMotionDataViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import UIKit

class DataViewController: UIViewController {
    //MARK: Oulets
    // Accelerometer Oulets
    @IBOutlet weak var accelerationXLabel: UILabel!
    @IBOutlet weak var accelerationYLabel: UILabel!
    @IBOutlet weak var accelerationZLabel: UILabel!
    @IBOutlet weak var accelerationPositionLabel: UILabel!
    @IBOutlet weak var accelerationTitleView: UIView!
    @IBOutlet weak var accelerationDataView: UIView!
    // Gyro Oulets
    @IBOutlet weak var gyroXLabel: UILabel!
    @IBOutlet weak var gyroYLabel: UILabel!
    @IBOutlet weak var gyroZLabel: UILabel!
    @IBOutlet weak var gyroPositionLabel: UILabel!
    @IBOutlet weak var gyroTitleView: UIView!
    @IBOutlet weak var gyroDataView: UIView!
    // Magnetometer Oulets
    @IBOutlet weak var magneticFieldXLabel: UILabel!
    @IBOutlet weak var magneticFieldYLabel: UILabel!
    @IBOutlet weak var magneticFieldZLabel: UILabel!
    @IBOutlet weak var magneticFieldTitleView: UIView!
    @IBOutlet weak var magneticFieldDataView: UIView!
    // Device Motion Oulets
    @IBOutlet weak var attitudeYawLabel: UILabel!
    @IBOutlet weak var attitudeRollLabel: UILabel!
    @IBOutlet weak var attitudePitchLabel: UILabel!
    @IBOutlet weak var attitudeHeadingLabel: UILabel!
    @IBOutlet weak var gravityXLabel: UILabel!
    @IBOutlet weak var gravityYLabel: UILabel!
    @IBOutlet weak var gravityZLabel: UILabel!
    @IBOutlet weak var deviceMotionTitleView: UIView!
    @IBOutlet weak var deviceMotionDataView: UIView!
    // Pedometer Oulets
    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var motionStateLabel: UILabel!
    @IBOutlet weak var pedometerTitleView: UIView!
    @IBOutlet weak var pedometerDataView: UIView!
    // Motion Activity Outlets
    @IBOutlet weak var motionActivityTitleView: UIView!
    @IBOutlet weak var motionActivityView: UIView!
    // Start and Stop View
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: Variables
    let viewModel: DataViewModel
    var accelerometerSwitch: Bool!
    var magnetometerSwitch: Bool!
    var gyroSwitch: Bool!
    var deviceMotionSwitch: Bool!
    var pedometerSwitch: Bool!
    var motionActivitySwitch: Bool!
    
    
    // Dependency Injection
    init(viewModel: DataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = DataViewModel()
        super.init(coder: aDecoder)
    }

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DataViewController - viewDidLoad")
        loadViews()
        bindViewModel()
    }
    
    //MARK: Functions
    private func loadViews() {
        accelerationTitleView.isHidden = !accelerometerSwitch
        accelerationDataView.isHidden = !accelerometerSwitch
        gyroTitleView.isHidden = !gyroSwitch
        gyroDataView.isHidden = !gyroSwitch
        magneticFieldTitleView.isHidden = !magnetometerSwitch
        magneticFieldDataView.isHidden = !magnetometerSwitch
        deviceMotionTitleView.isHidden = !deviceMotionSwitch
        deviceMotionDataView.isHidden = !deviceMotionSwitch
        pedometerTitleView.isHidden = !pedometerSwitch
        pedometerDataView.isHidden = !pedometerSwitch
        motionActivityTitleView.isHidden = !motionActivitySwitch
        motionActivityView.isHidden = !motionActivitySwitch
        navigationItem.title = NSLocalizedString("core_motion_title", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("back_button", comment: ""), style: .done, target: self, action: #selector(dismissViewController))
        stepCounterLabel.text = "Step Counter: 0"
    }
    
    func bindViewModel() {
        viewModel.accelerometerSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.accelerationXLabel.text = "Acceleration X: \(data.acceleration.x.description)"
                self?.accelerationYLabel.text = "Acceleration Y: \(data.acceleration.y.description)"
                self?.accelerationZLabel.text = "Acceleration Z: \(data.acceleration.z.description)"
                self?.accelerationPositionLabel.text = self?.viewModel.getAccelerometerPosition(data.acceleration)
            }
        }
        
        viewModel.gyroscopeSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.gyroXLabel.text = "Rotation X: \(data.rotationRate.x.description)"
                self?.gyroYLabel.text = "Rotation Y: \(data.rotationRate.y.description)"
                self?.gyroZLabel.text = "Rotation Z: \(data.rotationRate.z.description)"
                self?.gyroPositionLabel.text = self?.viewModel.getGyrometerPosition(data.rotationRate)
            }
        }
        
        viewModel.magnetometerSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.magneticFieldXLabel.text = "Magnetic field X: \(data.magneticField.x.description)"
                self?.magneticFieldYLabel.text = "Magnetic field Y: \(data.magneticField.y.description)"
                self?.magneticFieldZLabel.text = "Magnetic field Z: \(data.magneticField.z.description)"
            }
        }
        
        viewModel.deviceMotionSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.attitudeYawLabel.text = "Attitude - Yaw: \(data.attitude.yaw.description)"
                self?.attitudeRollLabel.text = "Attitude - Roll: \(data.attitude.roll.description)"
                self?.attitudePitchLabel.text = "Attitude - Pitch: \(data.attitude.pitch.description)"
                self?.attitudeHeadingLabel.text = "Heading: \(data.heading)"
                self?.gravityXLabel.text = "Gravity - X: \(data.gravity.x.description)"
                self?.gravityYLabel.text = "Gravity - Y: \(data.gravity.y.description)"
                self?.gravityZLabel.text = "Gravity - Z: \(data.gravity.z.description)"
            }
        }
        
        viewModel.pedometerSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                self?.stepCounterLabel.text = "Step Counter: \(data.numberOfSteps.description)"
            }
        }
        
        viewModel.motionControlSensorUpdated = { [weak self] data in
            DispatchQueue.main.async {
                guard let activity = self?.viewModel.determineActivityState(activity: data) else { return }
                self?.motionStateLabel.text = "Motion State: \(activity)"
            }
        }
    }
    
    @objc private func dismissViewController() {
        SensorManager.shared.stopAllEnabledSensors()
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpButtonState(state: Bool) {
        if state {
            self.startButton.backgroundColor = UIColor(named: "RubyRed")
            self.startButton.setTitle(NSLocalizedString("stop_button", comment: ""), for: .normal)
        } else {
            self.startButton.backgroundColor = UIColor(named: "SafetyBlue")
            self.startButton.setTitle(NSLocalizedString("start_button", comment: ""), for: .normal)
        }
    }
    
    // MARK: Actions
    @IBAction func startButtonAction(_ sender: Any) {
        viewModel.toggleSensors()
    }
    
    @IBAction func logsButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goToLogs", sender: self)
    }
    
    // MARK: Navigation and Segue handler
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "goToLogs" {
            if let vc = segue.destination as? LogViewController {
                vc.accelerometerSwitch = accelerometerSwitch
                vc.gyroSwitch = gyroSwitch
                vc.magnetometerSwitch = magnetometerSwitch
                vc.deviceMotionSwitch = deviceMotionSwitch
                vc.pedometerSwitch = pedometerSwitch
                vc.motionActivitySwitch = motionActivitySwitch
            }
        }
    }
}
