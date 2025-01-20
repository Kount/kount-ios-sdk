//
//  LibraryKitViewController.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 27-05-24.
//

import UIKit
import KountUI

class LibraryKitViewController: UIViewController {
    private let viewModel: LibraryKitViewModel
    private var tableView: UITableView!
    
    init() {
        self.viewModel = LibraryKitViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = LibraryKitViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LibraryKitViewController")
        setupView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarHelper.setupLargeTitleNavigation(for: self, prefersLargeTitles: false,
                                                      largeTitleDisplayMode: self.navigationItem,
                                                      title: "Library Kit",
                                                      backgroundColor: ColorPalette.darkBackground,
                                                      textColor: ColorPalette.textPrimary)
    }
    
    private func setupView() {
        view.backgroundColor = ColorPalette.lightBackground
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DemoViewCell.self, forCellReuseIdentifier: "LibraryCell")
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.backgroundColor = ColorPalette.lightBackground
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension LibraryKitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryCell", for: indexPath) as! DemoViewCell
        let option = viewModel.options[indexPath.row]
        cell.configure(with: option)
        cell.isUserInteractionEnabled = option.isEnabled
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = viewModel.options[indexPath.row]
        
        let libraryCategory: LibraryCategory 
        switch option.title {
        case "CoreMotion":
            libraryCategory = .coreMotion
        case "Darwin":
            libraryCategory = .darwin
        case "System":
            libraryCategory = .system
        case "UIKit":
            libraryCategory = .uiKit
        default: 
            return
        }
        
        let libraryPickerViewController = LibraryPickerViewController(libraryCategory: libraryCategory)
        navigationController?.pushViewController(libraryPickerViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
