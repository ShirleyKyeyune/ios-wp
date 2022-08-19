//
//  ColorThemeSettingsCell.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import Foundation
import UIKit

protocol ColorThemeSettingsCellDelegste: AnyObject {
    func presentColorThemes()
}

class ColorThemeSettingsCell: UITableViewCell, ReloadColorThemeProtocol {
    
    // MARK: - Properties
    
    var colorThemeComponent: ColorThemeProtocol
    weak var delegate: ColorThemeSettingsCellDelegste?
    
    // MARK: - Private properties
    
    private lazy var themeIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: WPConstants.SystemImageName.paintbrush, withConfiguration: imageConfiguration) ?? UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        label.text = "Theme"
        return label
    }()
    
    private let themeColorBlocksView = ThemeColorBlocksView()
    
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = WPSize.pt12
        return stack
    }()
    
    // MARK: - Constructions
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(style: .default, reuseIdentifier: nil)
        
        refresh()
        
        leftStackView.addArrangedSubview(themeIcon)
        leftStackView.addArrangedSubview(themeLabel)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(themeColorBlocksView)
        
        contentView.addSubview(mainStackView)
        selectionStyle = .none
        
        reloadColorTheme()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        themeIcon.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        themeLabel.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
    }
    
    func refresh() {
        themeColorBlocksView.setupBlocks(colorThemeComponent.colorTheme.settingsScreen.colorBoxesColors)
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: WPSize.pt20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -WPSize.pt20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: WPSize.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -WPSize.pt20).isActive = true
    }
}

extension ColorThemeSettingsCell: SettingsCellTappableProtocol {
    func tapCell() {
        delegate?.presentColorThemes()
    }
}
