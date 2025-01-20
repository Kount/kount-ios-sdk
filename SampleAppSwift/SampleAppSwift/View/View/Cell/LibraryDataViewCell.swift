//
//  LibraryDataViewCell.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 13-06-24.
//

import UIKit
import KountUI

class LibraryDataViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private let separatorView = UIView()
    private let iconImageView = UIImageView()
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = ColorPalette.textSecondary
        titleLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.spacing = 6
        separatorView.backgroundColor = ColorPalette.lightBackground
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = ColorPalette.lightBackground.cgColor
        containerView.backgroundColor = ColorPalette.textPrimary
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(separatorView)
        containerView.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            separatorView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with libraryType: LibraryType, data: [String: String], orderedKeys: [String], image: UIImage?) {
        titleLabel.text = libraryType.formattedTitle()
        iconImageView.image = image
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for key in orderedKeys {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .equalSpacing
            
            let keyLabel = UILabel()
            keyLabel.numberOfLines = 0
            keyLabel.text = key
            keyLabel.textColor = .black
            
            let valueLabel = UILabel()
            valueLabel.numberOfLines = 0
            valueLabel.font = UIFont.boldSystemFont(ofSize: keyLabel.font.pointSize)
            valueLabel.text = data[key] ?? "..."
            valueLabel.textColor = .black
            
            horizontalStackView.addArrangedSubview(keyLabel)
            horizontalStackView.addArrangedSubview(valueLabel)
            
            stackView.addArrangedSubview(horizontalStackView)
        }
    }
}
