//
//  TemperatureItemView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

class TemperatureItemView: UIView {

    // MARK: - Public properties

    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 2.0
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: WPSize.pt18)
        return label
    }()

    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        return label
    }()

    // MARK: - Construction

    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(subTitleLabel)
        addSubview(stackView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func setupConstraints() {
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: WPSize.pt4).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
