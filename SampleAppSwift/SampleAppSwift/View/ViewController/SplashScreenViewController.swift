//
//  SplashScreenViewController.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 12-06-24.
//

import UIKit
import KountUI

class SplashScreenViewController: UIViewController {
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashScreenViewController")
        setupView()
    }
    
    private func setupView() {
        if let splashScreen = UIComponents.uikit.splashScreen(style: .lottieAnimation(name: "splashAnimation")).render(completion: {
        }) as? UIView {
            splashScreen.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(splashScreen)
            
            NSLayoutConstraint.activate([
                splashScreen.topAnchor.constraint(equalTo: view.topAnchor),
                splashScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                splashScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                splashScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        scheduleAutomaticTransition()
    }
    
    private func scheduleTransition() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(transitionToMainViewController), userInfo: nil, repeats: false)
    }
    
    private func scheduleAutomaticTransition() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.transitionToMainViewController()
        }
    }
    
    @objc private func transitionToMainViewController() {
        guard timer == nil else {
            return
        }
        
        let navigationController = UINavigationController(rootViewController: DemoMenuViewController())
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
