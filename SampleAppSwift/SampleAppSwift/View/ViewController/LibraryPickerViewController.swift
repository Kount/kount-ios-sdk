//
//  LibraryPickerViewController.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 06-11-23.
//

import UIKit
import KountUI

class LibraryPickerViewController: UIViewController {
    private var viewModel: LibraryPickerViewModel
    private var tableView: UITableView!
    private var startTestingButton: UIBarButtonItem!
    
    init(libraryCategory: LibraryCategory) {
        self.viewModel = LibraryPickerViewModel(libraryCategory: libraryCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = LibraryPickerViewModel(libraryCategory: .coreMotion)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LibraryPickerViewController")
        setupNavigationBar()
        setupView()
        setupTableView()
        updateStartTestingButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarHelper.setupLargeTitleNavigation(for: self, prefersLargeTitles: false, largeTitleDisplayMode: self.navigationItem, title: viewModel.title, backgroundColor: ColorPalette.darkBackground, textColor: ColorPalette.textPrimary)
    }
    
    private func setupNavigationBar() {
        startTestingButton = UIBarButtonItem(
            title: "Start Testing",
            style: .done,
            target: self,
            action: #selector(button1Tapped)
        )
        navigationItem.rightBarButtonItem = startTestingButton
    }
    
    private func setupView() {
        view.backgroundColor = ColorPalette.lightBackground
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = ColorPalette.lightBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LibraryViewCell.self, forCellReuseIdentifier: "CoreMotionLibraryCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 72, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateStartTestingButtonState() {
        startTestingButton.isEnabled = viewModel.libraryOptions.contains(where: { $0.isEnabled })
    }
    
    @objc private func button1Tapped() {
        let enabledLibraries = viewModel.libraryOptions.filter({ $0.isEnabled }).map { $0.libraryType }
        let nextViewController = DataVisualizerViewController(enabledLibraries: enabledLibraries, viewModel: DataVisualizerViewModel(enabledLibraries: enabledLibraries))
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension LibraryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.libraryOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoreMotionLibraryCell", for: indexPath) as? LibraryViewCell else {
            return UITableViewCell()
        }
        
        let option = viewModel.libraryOptions[indexPath.row]
        cell.configure(with: option.title, isEnabled: option.isEnabled)
        cell.selectionStyle = .none
        cell.switchControl.tag = indexPath.row
        cell.switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        viewModel.toggleLibrary(at: index)
        updateStartTestingButtonState()
    }
}
