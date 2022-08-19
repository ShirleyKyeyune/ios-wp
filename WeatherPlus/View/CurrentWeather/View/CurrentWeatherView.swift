//
//  CurrentWeatherView.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit

protocol CurrentWeatherViewProtocol: UIView {
    func updateData(currentViewType: CurrentWeatherViewType)
    func viewWillLayoutUpdate()
    func showLoadingView(isVisible: Bool)
}

class CurrentWeatherView: UIView, CurrentWeatherViewProtocol {

    // MARK: - Public properties

    weak var viewControllerOwner: CurrentWeatherViewControllerDelegate?
    var colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Private properties
    
    private lazy var navigationBarBlurBackground: UIVisualEffectView = {
        let isNavBarDark = colorThemeComponent.colorTheme.cityDetails.isNavBarDark
        let view = UIVisualEffectView(effect: UIBlurEffect(style: isNavBarDark ? .dark : .light))
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Screen first part

    private var topTranslucentBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var degreeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = WPSize.pt8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: WPConstants.ImageName.sunnyBackground)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var tempLebel: DegreeLabel = {
        let label = DegreeLabel()
        label.accessibilityIdentifier = "CityDetailsMainDegreeLabel"
        label.font = UIFont.systemFont(ofSize: WPSize.pt56, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WPSize.pt32, weight: .regular)
        return label
    }()
    
    private var loadingView: CurrentWeatherLoadingView = {
        let loadingView = CurrentWeatherLoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    // MARK: - Screen second part

    private lazy var secondScreenPartBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var temperatureInfoView: TemperatureInfoView = {
        let temperatureInfoView = TemperatureInfoView(colorThemeComponent: colorThemeComponent)
        temperatureInfoView.translatesAutoresizingMaskIntoConstraints = false
        return temperatureInfoView
    }()

    private lazy var weeklyForecastTableView: WeeklyTableView = {
        let weeklyTableView = WeeklyTableView(colorThemeComponent: colorThemeComponent)
        weeklyTableView.translatesAutoresizingMaskIntoConstraints = false
        return weeklyTableView
    }()

    // Constraints
    private let temperatureInfoHeightConstant: CGFloat = WPSize.pt52
    private var temperatureInfoTopConstant: CGFloat = 0.0
    private let springDefaultConstant: CGFloat = 0.0 //WPSize.pt52

    private var temperatureInfoHeightConstraint = NSLayoutConstraint()
    private var weeklyTableViewHightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var springConstraint: NSLayoutConstraint = NSLayoutConstraint()

    // Background views
    private let gradientBackground = CAGradientLayer()

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(frame: .zero)

        scrollView.delegate = self
        
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topTranslucentBackground)
        
        let backgroundColors = colorThemeComponent.colorTheme.cityDetails.screenBackground
        tempLebel.textColor = backgroundColors.labelsColor
        descriptionLabel.textColor = backgroundColors.labelsColor
        
        degreeStackView.addArrangedSubview(tempLebel)
        degreeStackView.addArrangedSubview(descriptionLabel)
        degreeStackView.addArrangedSubview(loadingView)
        
        topTranslucentBackground.addSubview(conditionImage)
        topTranslucentBackground.addSubview(degreeStackView)

        scrollContentView.addSubview(secondScreenPartBackground)
        secondScreenPartBackground.addSubview(temperatureInfoView)
        
        secondScreenPartBackground.addSubview(weeklyForecastTableView)
        
        addSubview(navigationBarBlurBackground)
        
        setUpConstraints()
        setupBackgroundColor(color: WPConstants.Colors.WeatherBg.sunnyColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func viewWillLayoutUpdate() {
        // Set tableview height according to its contents
        weeklyTableViewHightConstraint.constant = weeklyForecastTableView.tableViewContentHeight + WPSize.pt40
        gradientBackground.frame = bounds
        scrollView.contentSize = scrollContentView.bounds.size
        
        setUpNavBar()
    }
    
    func updateData(currentViewType: CurrentWeatherViewType) {
        let conditionColor = currentViewType.weatherStyle.colorHex
        setupBackgroundColor(color: UIColor(conditionColor))
        setLabelsAndImages(with: currentViewType)
        temperatureInfoView.updateDataSource(weatherData: currentViewType)
        weeklyForecastTableView.reloadData(currentViewType)
    }
    
    func showLoadingView(isVisible: Bool) {
        loadingView.isHidden = !isVisible
        degreeStackView.layoutIfNeeded()
    }
    
    // MARK: - Private Functions
    
    private func updateAlphaViews() {
        // Handle navigation bar appearance according to the scroll view offset
        let targetHeight = (topTranslucentBackground.bounds.height - degreeStackView.bounds.height)
            / 2 - navigationBarBlurBackground.bounds.height
        // Calculate how much has been scrolled relative to the target
        let offset = scrollView.contentOffset.y / targetHeight
        navigationBarBlurBackground.alpha = offset
    }

    private func updateAnimatedViews() {
        // Spring constant will change its value by scrolling to half of its size
        let oldConstant = temperatureInfoTopConstant
        let newConstant: CGFloat

        if scrollView.contentOffset.y < temperatureInfoTopConstant / 2 {
            newConstant = springDefaultConstant
        } else {
            newConstant = WPSize.pt24
        }

        if oldConstant != newConstant {
            UIView.animate(withDuration: 0.1) {
                self.springConstraint.constant = newConstant
                self.layoutIfNeeded()
            }
        }
    }

    private func setUpConstraints() {
        setUpScrollView()
        setUpScrollContentView()
        setUpTopTranslucentView()
        setUpDegreeStackView()
        setUpConditionImage()
        setUpBottombackgroundView()
        setupTemperatureInfoView()
        setUpWeeklyTableViewHeightConstraint()
    }
    
    private func setUpNavBar() {
        navigationBarBlurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navigationBarBlurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navigationBarBlurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let navBarHeight = viewControllerOwner?.getNavigationBar()?.bounds.height ?? 0
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let overallNavBarHeight = navBarHeight + statusBarHeight
        
        navigationBarBlurBackground.heightAnchor.constraint(equalToConstant: overallNavBarHeight).isActive = true
    }

    private func setLabelsAndImages(with newData: CurrentWeatherViewType) {
        let conditionImageName = newData.weatherStyle.backgroundImage
        
        if let image = UIImage(named: conditionImageName) {
            conditionImage.image = image
        }

        tempLebel.text = newData.temperatureString
        descriptionLabel.text = newData.weatherStyle.title

        temperatureInfoView.updateDataSource(weatherData: newData)
        weeklyForecastTableView.reloadData(newData)
    }
}

// MARK: - ScrollView

extension CurrentWeatherView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
            return
        }

        updateAlphaViews()
        guard temperatureInfoView.isVisible() else {
            return
        }

        updateAnimatedViews()
    }
}

// MARK: - SetUp constraints

extension CurrentWeatherView {
    private func setUpConditionImage() {
        conditionImage.topAnchor.constraint(equalTo: topTranslucentBackground.topAnchor).isActive = true
        conditionImage.leadingAnchor.constraint(equalTo: topTranslucentBackground.leadingAnchor).isActive = true
        conditionImage.trailingAnchor.constraint(equalTo: topTranslucentBackground.trailingAnchor).isActive = true
        conditionImage.bottomAnchor.constraint(equalTo: topTranslucentBackground.bottomAnchor, constant: WPSize.pt8).isActive = true
    }

    private func setUpWeeklyTableViewHeightConstraint() {
        weeklyForecastTableView.topAnchor.constraint(equalTo: temperatureInfoView.bottomAnchor, constant: WPSize.pt16).isActive = true
        weeklyForecastTableView.leadingAnchor.constraint(equalTo: secondScreenPartBackground.leadingAnchor).isActive = true
        weeklyForecastTableView.trailingAnchor.constraint(equalTo: secondScreenPartBackground.trailingAnchor).isActive = true
        
        weeklyTableViewHightConstraint = NSLayoutConstraint(item:
                                                                weeklyForecastTableView,
                                                            attribute: .height,
                                                            relatedBy: .equal,
                                                            toItem: nil,
                                                            attribute: .height,
                                                            multiplier: 1,
                                                            constant: 0)
        weeklyTableViewHightConstraint.isActive = true
    }

    private func setUpDegreeStackView() {
        degreeStackView.centerYAnchor.constraint(equalTo: topTranslucentBackground.centerYAnchor, constant: WPSize.pt16).isActive = true
        degreeStackView.centerXAnchor.constraint(equalTo: topTranslucentBackground.centerXAnchor).isActive = true
    }

    private func setUpBottombackgroundView() {
        secondScreenPartBackground.topAnchor.constraint(equalTo: topTranslucentBackground.bottomAnchor).isActive = true
        secondScreenPartBackground.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        secondScreenPartBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        secondScreenPartBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
    }

    private func setUpTopTranslucentView() {
        topTranslucentBackground.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        topTranslucentBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        topTranslucentBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        topTranslucentBackground.heightAnchor.constraint(equalToConstant:
                                                            (UIScreen.main.bounds.height * 0.5) - WPSize.pt84).isActive = true
    }

    private func setUpScrollView() {
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    private func setUpScrollContentView() {
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setupTemperatureInfoView() {
        temperatureInfoView.topAnchor.constraint(equalTo: secondScreenPartBackground.topAnchor).isActive = true
        temperatureInfoView.leadingAnchor.constraint(equalTo: secondScreenPartBackground.leadingAnchor).isActive = true
        temperatureInfoView.trailingAnchor.constraint(equalTo: secondScreenPartBackground.trailingAnchor).isActive = true
        temperatureInfoView.heightAnchor.constraint(equalToConstant: temperatureInfoHeightConstant).isActive = true
    }

    private func setupGradientBackground(color conditionColor: UIColor) {
        var cgColors: [CGColor] = []
        cgColors.append(conditionColor.cgColor)
        cgColors.append(conditionColor.cgColor)
        gradientBackground.colors = cgColors
        layer.insertSublayer(gradientBackground, at: 0)
    }
    
    private func setupBackgroundColor(color conditionColor: UIColor) {
        setupGradientBackground(color: conditionColor)
        temperatureInfoView.backgroundColor = conditionColor
        secondScreenPartBackground.backgroundColor = conditionColor
        backgroundColor = conditionColor
    }
}
