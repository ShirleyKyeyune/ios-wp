//
//  LoadingCell.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let gradient = CAGradientLayer()
    
    private var cityLoadView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeLoadView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var degreeLoadView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var weatherBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = WPSize.pt8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var leftStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = WPSize.pt8
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var rightStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.spacing = WPSize.pt32
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = false
        selectionStyle = .none
        
        // Setting up cell appearance
        DesignManager.setBackgroundStandardShape(layer: weatherBackgroundView.layer)
        DesignManager.setBackgroundStandardShadow(layer: weatherBackgroundView.layer)
        
        // Making cells shadow be able to spill over other cells
        layer.masksToBounds = false
        backgroundColor = .clear
        
        // Setting up gradient layer
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        gradient.colors = DesignManager.getStandardGradientColor(withStyle: .blank)
        
        weatherBackgroundView.layer.insertSublayer(gradient, at: 0) // Adding gradient at the bottom
        
        activityIndicator.startAnimating()
        
        leftStackView.addArrangedSubview(cityLoadView)
        leftStackView.addArrangedSubview(timeLoadView)
        
        rightStackView.addArrangedSubview(activityIndicator)
        rightStackView.addArrangedSubview(degreeLoadView)
        
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        addSubview(weatherBackgroundView)
        weatherBackgroundView.addSubview(mainStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        DesignManager.setBackgroundStandardShape(layer: gradient)
        
        // Setting up grey lines corners
        cityLoadView.layer.cornerRadius = WPSize.pt4
        timeLoadView.layer.cornerRadius = WPSize.pt4
        degreeLoadView.layer.cornerRadius = WPSize.pt8
        
        setUpConstraints()
    }
    
    // MARK: - Functions
    
    func setupColorTheme(colorTheme: ColorThemeProtocol) {
        let colorThemeCell = colorTheme.colorTheme.moreOptions.cells
        
        weatherBackgroundView.backgroundColor = colorThemeCell.defaultBackground
        cityLoadView.backgroundColor = colorThemeCell.defaultLoadingViewsColor
        timeLoadView.backgroundColor = colorThemeCell.defaultLoadingViewsColor
        degreeLoadView.backgroundColor = colorThemeCell.defaultLoadingViewsColor
        activityIndicator.color = colorThemeCell.activityViewColor
        
    }
    
    // MARK: - Private functions
    
    private func setUpConstraints() {
        // Background
        weatherBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: WPSize.pt4).isActive = true
        weatherBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -WPSize.pt4).isActive = true
        weatherBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: WPSize.pt16).isActive = true
        weatherBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -WPSize.pt16).isActive = true
        
        // LoadingTitle
        let cityLoadViewHeightConstraint = cityLoadView.heightAnchor.constraint(equalToConstant: WPSize.pt20)
        cityLoadViewHeightConstraint.priority = UILayoutPriority(999)
        cityLoadViewHeightConstraint.isActive = true
        
        let cityLoadViewWidthConstraint = cityLoadView.widthAnchor.constraint(equalToConstant: WPSize.pt100)
        cityLoadViewWidthConstraint.priority = UILayoutPriority(999)
        cityLoadViewWidthConstraint.isActive = true
        
        // Loading time
        let timeLoadViewHeightConstraint = timeLoadView.heightAnchor.constraint(equalToConstant: WPSize.pt16)
        timeLoadViewHeightConstraint.priority = UILayoutPriority(999)
        timeLoadViewHeightConstraint.isActive = true
        
        let timeLoadViewWidthConstraint = timeLoadView.widthAnchor.constraint(equalToConstant: WPSize.pt60)
        timeLoadViewWidthConstraint.priority = UILayoutPriority(999)
        timeLoadViewWidthConstraint.isActive = true
        
        // Degree view
        degreeLoadView.heightAnchor.constraint(equalToConstant: WPSize.pt44).isActive = true
        degreeLoadView.widthAnchor.constraint(equalToConstant: WPSize.pt44).isActive = true
        
        // MainStackView
        mainStackView.topAnchor.constraint(equalTo: weatherBackgroundView.topAnchor, constant: WPSize.pt16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: weatherBackgroundView.bottomAnchor,
                                              constant: -WPSize.pt16).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: weatherBackgroundView.leadingAnchor,
                                               constant: WPSize.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: weatherBackgroundView.trailingAnchor,
                                                constant: -WPSize.pt20).isActive = true
    }
}
