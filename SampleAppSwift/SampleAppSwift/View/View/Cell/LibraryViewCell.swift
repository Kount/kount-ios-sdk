//
//  LibraryViewCell.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 13-06-24.
//

import UIKit
import KountUI

class LibraryViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let switchControl = UISwitch()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = ColorPalette.lightBackground
        contentView.backgroundColor = .clear
        
        titleLabel.textColor = .black
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = ColorPalette.lightBackground.cgColor
        containerView.backgroundColor = ColorPalette.textPrimary
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        switchControl.onTintColor = ColorPalette.primary
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(switchControl)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            switchControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with title: String, isEnabled: Bool) {
        titleLabel.text = title
        switchControl.isOn = isEnabled
    }
}
