//
//  WelcomeViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 20-10-23.
//

import UIKit

class WelcomeViewController: UIViewController {
    //MARK: Oulets
    @IBOutlet weak var coreMotionButton: UIButton!
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    var viewModel: WelcomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WelcomeViewController - viewDidLoad")
        viewModel = WelcomeViewModel()
        loadViews()
        bindViewModel()
    }
    
    @IBAction func changeLanguageTapped(_ sender: Any) {
        viewModel.openSettings()
    }
    
    private func loadViews() {
        // Sets title button title
        coreMotionButton.setTitle(NSLocalizedString("core_motion_title", comment: ""), for: .normal)
        changeLanguageButton.setTitle(NSLocalizedString("change_language_title", comment: ""), for: .normal)
    }
    
    func bindViewModel() {
        // Register Bindings
        viewModel.onOpenSettings = { [weak self] in
            self?.openDeviceSettings()
        }
    }
    
    private func openDeviceSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
