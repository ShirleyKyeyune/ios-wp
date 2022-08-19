//
//  CurrentWeatherLoadingView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import UIKit

class CurrentWeatherLoadingView: UIView {
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = WPSize.pt32
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = WPConstants.AppState.loading
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: WPSize.pt16)
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    init() {
        super.init(frame: .zero)
        
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        mainStackView.addArrangedSubview(activityIndicator)
        mainStackView.addArrangedSubview(loadingLabel)
        
        addSubview(mainStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: WPSize.pt4).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: WPSize.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -WPSize.pt20).isActive = true
        
    }
}
