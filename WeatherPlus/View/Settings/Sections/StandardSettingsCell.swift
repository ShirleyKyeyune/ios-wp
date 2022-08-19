//
//  StandardSettingsCell.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

class StandardSettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        label.text = title
        return label
    }()
    
    lazy var settingsIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: systemImageName, withConfiguration: imageConfiguration) ?? UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Private properties
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = WPSize.pt12
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let title: String
    private let systemImageName: String
    
    // MARK: - Construction
    
    init(title: String, systemImageName: String) {
        self.systemImageName = systemImageName
        self.title = title
        super.init(style: .default, reuseIdentifier: nil)
        
        stackView.addArrangedSubview(settingsIcon)
        stackView.addArrangedSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: WPSize.pt20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -WPSize.pt20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: WPSize.pt20).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -WPSize.pt20).isActive = true
    }
}
