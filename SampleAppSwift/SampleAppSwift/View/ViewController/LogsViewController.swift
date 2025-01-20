//
//  LogViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import UIKit

class LogViewController: UIViewController, UITableViewDataSource {
    //MARK: Oulets
    @IBOutlet weak var logsTableView: UITableView!
    @IBOutlet weak var stopButton: UIButton!
    
    //MARK: Variables
    var viewModel: LogViewModel!
    var accelerometerSwitch: Bool!
    var magnetometerSwitch: Bool!
    var gyroSwitch: Bool!
    var deviceMotionSwitch: Bool!
    var pedometerSwitch: Bool!
    var motionActivitySwitch: Bool!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LogViewController - viewDidLoad")
        viewModel = LogViewModel()
        loadViews()
        bindViewModel()
    }
    
    //MARK: Functions
    private func loadViews() {
        logsTableView.dataSource = self
        
        // Register your cell file:
        logsTableView.register(UINib(nibName: "LogsCell", bundle: nil), forCellReuseIdentifier: "logsCell")
        //logsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "logsCell")
        logsTableView.contentLayoutGuide.owningView?.backgroundColor = .white
        
        // Set navigation bar title and back button
        navigationItem.title = NSLocalizedString("core_motion_title", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("back_button", comment: ""), style: .done, target: self, action: #selector(dismissViewController))
    }
    
    func bindViewModel() {
        viewModel.onNewData = { [weak self] in
            DispatchQueue.main.async {
                self?.logsTableView.reloadData()
            }
        }
    }
    
    private func setUpButtonState(state: Bool) {
        if state {
            self.stopButton.backgroundColor = UIColor(named: "RubyRed")
            self.stopButton.setTitle(NSLocalizedString("stop_button", comment: ""), for: .normal)
        } else {
            self.stopButton.backgroundColor = UIColor(named: "SafetyBlue")
            self.stopButton.setTitle(NSLocalizedString("start_button", comment: ""), for: .normal)
        }
    }
    
    @objc private func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Actions
    @IBAction func stopButtonAction(_ sender: Any) {
        viewModel.toggleSensors()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SensorManager.shared.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "logsCell", for: indexPath) as? LogsCell else { fatalError("Could not deque cell a cell with identifier logsCell") }
        cell.logLabel.text = SensorManager.shared.logs[indexPath.row]
        return cell
    }
}
