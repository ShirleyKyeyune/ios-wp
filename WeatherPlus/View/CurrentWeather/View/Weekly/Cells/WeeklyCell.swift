//
//  WeeklyCell.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

class WeeklyCell: UITableViewCell {

    // MARK: - Public properties

    var weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        return label
    }()

    var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Private properties

    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Construxtion

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        mainStackView.addArrangedSubview(weekDayLabel)
        mainStackView.addArrangedSubview(temperatureLabel)
        addSubview(mainStackView)
        addSubview(conditionImage)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupColorTheme(_ colorTheme: ColorThemeProtocol) {
        let weeklyColors = colorTheme.colorTheme.cityDetails.weeklyForecast
        weekDayLabel.textColor = weeklyColors.labelsColor
        temperatureLabel.textColor = weeklyColors.labelsColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekDayLabel.font = UIFont.systemFont(ofSize: WPSize.pt16, weight: .regular)
        weekDayLabel.textColor = .black
        temperatureLabel.textColor = .black
    }

    // MARK: - Private functions

    private func setupConstraints() {
        // Main stack
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: WPSize.pt12).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -WPSize.pt12).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: WPSize.pt12).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -WPSize.pt12).isActive = true

        // Condition image
        conditionImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        conditionImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        conditionImage.heightAnchor.constraint(equalToConstant: WPSize.pt24).isActive = true
        conditionImage.widthAnchor.constraint(equalToConstant: WPSize.pt24).isActive = true
        
        // MonthLabel
        weekDayLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: WPSize.pt96).isActive = true
    }
}
