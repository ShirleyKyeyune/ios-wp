//
//  TemperatureInfoView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

class TemperatureInfoView: UIView {
    
    // MARK: - Private properties
    
    private var colorThemeComponent: ColorThemeProtocol
    
    private var backgroundView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = WPSize.pt6
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var minItemView: TemperatureItemView = {
        let temperatureItem = TemperatureItemView()
        temperatureItem.temperatureLabel.text = String(format: "%.0f°", 20)
        temperatureItem.temperatureLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsColor
        temperatureItem.subTitleLabel.text = "min"
        temperatureItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsSecondaryColor
        return temperatureItem
    }()
    
    private lazy var currentItemView: TemperatureItemView = {
        let temperatureItem = TemperatureItemView()
        temperatureItem.temperatureLabel.text = String(format: "%.0f°", 25)
        temperatureItem.temperatureLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsColor
        temperatureItem.subTitleLabel.text = "Current"
        temperatureItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsSecondaryColor
        return temperatureItem
    }()
    
    private lazy var maxItemView: TemperatureItemView = {
        let temperatureItem = TemperatureItemView()
        temperatureItem.temperatureLabel.text = String(format: "%.0f°", 27)
        temperatureItem.temperatureLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsColor
        temperatureItem.subTitleLabel.text = "max"
        temperatureItem.subTitleLabel.textColor = colorThemeComponent.colorTheme.cityDetails.temperatureItem.labelsSecondaryColor
        return temperatureItem
    }()
    
    private lazy var dividerView: UIView = {
        let divider = UIView()
        divider.backgroundColor = .white
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    // StackViews
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = WPSize.pt32
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Construction
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)
        
        mainStackView.addArrangedSubview(minItemView)
        mainStackView.addArrangedSubview(currentItemView)
        mainStackView.addArrangedSubview(maxItemView)
        
        addSubview(backgroundView)
        backgroundView.addArrangedSubview(mainStackView)
        backgroundView.addArrangedSubview(dividerView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func updateDataSource(weatherData: CurrentWeatherViewType) {
        minItemView.temperatureLabel.text = weatherData.minTemperatureString
        currentItemView.temperatureLabel.text = weatherData.temperatureString
        maxItemView.temperatureLabel.text = weatherData.maxTemperatureString
        
        minItemView.stackView.layoutIfNeeded()
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        // BackgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1.2).isActive = true
        
        // Main stackView
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: WPSize.pt4).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: WPSize.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -WPSize.pt20).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func makeStackViewItemInfo(image: UIImageView, title: UILabel, subtitle: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        return stackView
    }
}

