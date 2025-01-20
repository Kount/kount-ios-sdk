//
//  DemoViewCell.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 13-06-24.
//

import UIKit
import KountUI

class DemoViewCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
        iconImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = ColorPalette.lightBackground.cgColor
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(with option: LibraryKitOption) {
        titleLabel.text = option.title
        if let image = UIImage(named: option.imageName) {
            iconImageView.image = image
            iconImageView.tintColor = option.isEnabled ? nil : ColorPalette.textDisable
            iconImageView.image = image.withRenderingMode(.alwaysTemplate)
            titleLabel.textColor = option.isEnabled ? .black : ColorPalette.textDisable
            containerView.backgroundColor = option.isEnabled ? ColorPalette.textPrimary : ColorPalette.lightShade
        }
    }
}
