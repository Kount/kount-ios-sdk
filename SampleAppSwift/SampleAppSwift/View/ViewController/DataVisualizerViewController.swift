//
//  DataVisualizerViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import UIKit
import KountUI

class DataVisualizerViewController: UIViewController {
    private var viewModel: DataVisualizerViewModel!
    private var tableView: UITableView!
    private var playPauseButton: UIButton!
    private var enabledLibraries: [LibraryType] = []
    private var libraryData: [LibraryType: [String: String]] = [:]
    private var hasLiveUpdateLibraries: Bool = false
    
    init(enabledLibraries: [LibraryType], viewModel: DataVisualizerViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.enabledLibraries = enabledLibraries
        self.viewModel = viewModel
        
        // Initialize libraryData with default values
        for library in enabledLibraries {
            if let libraryInstance = LibraryFactory.createLibrary(for: library, observer: viewModel) as? Library {
                libraryData[library] = libraryInstance.parameters.reduce(into: [String: String]()) { result, param in
                    result[param.name] = param.value
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupPlayPauseButtonIfNeeded()
        setupViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = ColorPalette.darkBackground
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LibraryDataViewCell.self, forCellReuseIdentifier: "LibraryDataCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(cgColor: ColorPalette.lightBackground.cgColor)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 112, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 76.0
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupPlayPauseButtonIfNeeded() {
        hasLiveUpdateLibraries = enabledLibraries.contains { libraryType in
            LibraryFactory.createLibrary(for: libraryType, observer: viewModel).parameters.contains { $0.requiresLiveUpdates }
        }
        
        if hasLiveUpdateLibraries {
            setupPlayPauseButton()
        }
    }
    
    private func setupPlayPauseButton() {
        playPauseButton = UIButton(type: .custom)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.setImage(UIImage(named: "pauseIcon"), for: .normal)
        playPauseButton.setImage(UIImage(named: "playIcon"), for: .selected)
        playPauseButton.addTarget(self, action: #selector(toggleLibraries), for: .touchUpInside)
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            playPauseButton.widthAnchor.constraint(equalToConstant: 48),
            playPauseButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func toggleLibraries() {
        viewModel.toggleLibraries()
        playPauseButton.isSelected.toggle()
    }
    
    private func setupViewModel() {
        viewModel.libraryDataUpdated = { [weak self] libraryType, data in
            self?.updateLibraryData(for: libraryType, data: data)
        }
    }
    
    private func updateLibraryData(for libraryType: LibraryType, data: [String: String]) {
        libraryData[libraryType] = data
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        }
    }
}

extension DataVisualizerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return enabledLibraries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryDataCell", for: indexPath) as! LibraryDataViewCell
        
        let libraryType = enabledLibraries[indexPath.section]
        let data = libraryData[libraryType] ?? [:]
        
        cell.selectionStyle = .none
        cell.configure(with: libraryType, data: data, orderedKeys: libraryType.orderedKeys(), image: getImage(for: libraryType))
        cell.backgroundColor = UIColor(cgColor: ColorPalette.lightBackground.cgColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func getImage(for libraryType: LibraryType) -> UIImage? {
        switch libraryType {
            // CoreMotion
        case .accelerometer:
            return UIImage(named: "accelerometerIcon")
        case .altimeterAbsolute:
            return UIImage(named: "altimeterAbsoluteIcon")
        case .altimeterRelative:
            return UIImage(named: "altimeterRelativeIcon")
        case .deviceMotion:
            return UIImage(named: "deviceMotionIcon")
        case .gyroscope:
            return UIImage(named: "gyroscopeIcon")
        case .magnetometer:
            return UIImage(named: "magnetometerIcon")
        case .motionActivity:
            return UIImage(named: "motionActivityIcon")
        case .pedometer:
            return UIImage(named: "pedometerIcon")
            
            // Darwin
        case .kernelHardware:
            return UIImage(named: "kernelHardwareIcon")
            
            // System
        case .diskSpace:
            return UIImage(named: "diskIcon")
            
            //UIKit
        case .screenBrightness:
            return UIImage(named: "screenBrightnessIcon")
        case .deviceInfo:
            return UIImage(named: "deviceInfoIcon")
            
        }
    }
}
