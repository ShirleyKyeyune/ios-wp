//
//  UnitsCell.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

protocol UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int)
}

class UnitsCell: UITableViewCell, ReloadColorThemeProtocol {
    
    // MARK: - Public functions
    
    var delegate: UnitSwitchCellDelegate?
    
    // MARK: - Private properties
    
    private lazy var unitSwitch: UISegmentedControl = {
        let items = ["°C", "°F"]
        let switcher = UISegmentedControl(items: items)
        switcher.accessibilityIdentifier = WPConstants.AccessabilityIdentifier.settingsUnitSwitch
        switcher.selectedSegmentIndex = 0
        switcher.addTarget(self, action: #selector(unitSwitchToggled), for: .valueChanged)
        return switcher
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        label.text = "Temperature"
        return label
    }()
    
    private lazy var settingsIcon: UIImageView = {
        let imageView = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: WPConstants.SystemImageName.ruler, withConfiguration: imageConfiguration) ?? UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var temperatureCellStackView: UIStackView = {
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
    
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(style: .default, reuseIdentifier: nil)
        
        switch UserDefaultsManager.UnitData.get() {
            case WPConstants.UserDefaults.metric:
                unitSwitch.selectedSegmentIndex = 0
            case WPConstants.UserDefaults.imperial:
                unitSwitch.selectedSegmentIndex = 1
            default:
                unitSwitch.selectedSegmentIndex = 0
        }
        
        leftStackView.addArrangedSubview(settingsIcon)
        leftStackView.addArrangedSubview(temperatureLabel)
        
        temperatureCellStackView.addArrangedSubview(leftStackView)
        temperatureCellStackView.addArrangedSubview(unitSwitch)
        
        contentView.addSubview(temperatureCellStackView)
        selectionStyle = .none
        
        unitSwitch.widthAnchor.constraint(equalToConstant: WPSize.pt100).isActive = true
        
        reloadColorTheme()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func reloadColorTheme() {
        backgroundColor = colorThemeComponent.colorTheme.settingsScreen.cellsBackgroundColor
        unitSwitch.backgroundColor = colorThemeComponent.colorTheme.settingsScreen.temperatureSwitchColor
        unitSwitch.selectedSegmentTintColor = .white
        unitSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        temperatureLabel.textColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
        settingsIcon.tintColor = colorThemeComponent.colorTheme.settingsScreen.labelsSecondaryColor
    }
    
    // MARK: - Private functions
    
    func setupConstraints() {
        // TemperatureCell
        temperatureCellStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                      constant: WPSize.pt20).isActive = true
        temperatureCellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -WPSize.pt20).isActive = true
        temperatureCellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: WPSize.pt20).isActive = true
        temperatureCellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -WPSize.pt20).isActive = true
    }
    
    // MARK: - Actions
    
    @objc private func unitSwitchToggled() {
        delegate?.unitSwitchToggled(unitSwitch.selectedSegmentIndex)
    }
}
