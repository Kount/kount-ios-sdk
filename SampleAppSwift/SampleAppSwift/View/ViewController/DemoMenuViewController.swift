//
//  DemoMenuViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 20-10-23.
//

import UIKit
import KountUI

class DemoMenuViewController: UIViewController {
    private var libraryKitButton: UIButton?
    private var dataCollectionButton: UIButton?
    private var watermarkImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DemoMenuViewController")
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarHelper.setupLargeTitleNavigation(for: self, prefersLargeTitles: true, largeTitleDisplayMode: self.navigationItem, title: "Select a Demo", backgroundColor: ColorPalette.darkBackground, textColor: ColorPalette.textPrimary)
    }
    
    private func setupView() {
        view.backgroundColor = ColorPalette.lightBackground
        
        // Watermark Image
        let watermarkComponent = UIComponents.uikit.image()
        if let image = watermarkComponent.render(imageName: "kountWhite") as? UIImageView {
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            view.addSubview(image)
            self.watermarkImage = image
            
            NSLayoutConstraint.activate([
                image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
                image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
                image.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        // LibraryKitButton
        var libraryKitButtonComponent = UIComponents.uikit.button(style: .card(isEnabled: true))
        libraryKitButtonComponent.setText("Library Kit")
        if let button = libraryKitButtonComponent.render() as? UIButton {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(libraryKitButtonTapped), for: .touchUpInside)
            view.addSubview(button)
            self.libraryKitButton = button
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                button.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -12),
                button.heightAnchor.constraint(equalToConstant: (view.frame.width / 2) - 48),
                button.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 48),
            ])
        }
        
        // DataCollectionButton
        var dataCollectionButtonComponent = UIComponents.uikit.button(style: .card(isEnabled: false))
        dataCollectionButtonComponent.setText("Data Collection")
        if let button = dataCollectionButtonComponent.render() as? UIButton {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(dataCollectionButtonTapped), for: .touchUpInside)
            view.addSubview(button)
            self.dataCollectionButton = button
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                button.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 12),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                button.heightAnchor.constraint(equalToConstant: (view.frame.width / 2) - 48),
                button.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 48),
            ])
        }
    }
    
    @objc private func libraryKitButtonTapped() {
        let nextViewController = LibraryKitViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func dataCollectionButtonTapped() {
        // TO DO: Data Collection
    }
}
