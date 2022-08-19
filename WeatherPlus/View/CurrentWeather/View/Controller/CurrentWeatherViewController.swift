//
//  CurrentWeatherViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import UIKit
import Combine
import CoreLocation

protocol CurrentWeatherViewControllerDelegate: AnyObject {
    func getNavigationBar() -> UINavigationBar?
}

class CurrentWeatherViewController: UIViewController, CurrentWeatherViewControllerDelegate {

    private var viewModel: CurrentWeatherViewType
    private let input: PassthroughSubject<CurrentWeatherViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Private properties
    
    private lazy var mainView: CurrentWeatherViewProtocol = {
        let view = CurrentWeatherView(colorThemeComponent: appComponents)
        view.viewControllerOwner = self
        return view
    }()
    
    private lazy var backButtonNavBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonPressed))
        button.tintColor = appComponents.colorTheme.cityDetails.isStatusBarDark ? .black : .white
        
        return button
    }()
    
    private weak var updateTimer: Timer?
    
    let locationManager = CLLocationManager()

    var appComponents: AppComponents
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return appComponents.colorTheme.moreOptions.isStatusBarDark ? .darkContent : .lightContent
    }
    
    // MARK: - Lifecycle
    
    init(appComponents: AppComponents, viewModel: CurrentWeatherViewType = CurrentWeatherViewModel()) {
        self.appComponents = appComponents
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonNavBarItem.action = #selector(backButtonPressed)
        backButtonNavBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonNavBarItem

        let navBarTitleColor: UIColor = appComponents.colorTheme.cityDetails.isStatusBarDark ? .black : .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTitleColor]
        
        title = viewModel.cityTitle

        updateTimer = Timer.scheduledTimer(timeInterval: 240.0,
                                           target: self,
                                           selector: #selector(fetchWeatherData),
                                           userInfo: nil,
                                           repeats: true)
        updateTimer?.fire()
        
        setupBlurredNavigationBar()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
        setupLocation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.viewWillLayoutUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
    }
    
    // MARK: - Functions
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let `self` = self else {
                    return
                }
                switch event {
                    case .fetchWeatherDidSucceed:
                        self.mainView.updateData(currentViewType: self.viewModel)
                    case .fetchWeatherDidFail(let error):
                        self.didFailWithError(error: error)
                    case .showLoadingView(let isVisible):
                        self.mainView.showLoadingView(isVisible: isVisible)
                }
            }.store(in: &cancellables)
        
    }
    
    func getNavigationBar() -> UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    func showFavoriteLocations() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.newBackgroundContext()
        let destinationVC = MoreOptionsViewController(appComponents: appComponents,
                                                      managedContext: managedContext)
        
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.navigationBar.barStyle = .black
        
        self.dismiss(animated: false, completion: {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
        })
    }
    
    // MARK: - Private Functions
    
    // Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupBlurredNavigationBar() {
        getNavigationBar()?.shadowImage = UIImage()
        getNavigationBar()?.setBackgroundImage(UIImage(), for: .default)
        getNavigationBar()?.backgroundColor = .clear
    }

    // MARK: - Actions

    @objc func fetchWeatherData() {
        input.send(.refreshWeatherFired)
    }

    @objc func backButtonPressed() {
        showFavoriteLocations()
    }
    
    func didFailWithError(error: Error) {
        let alert = AlertViewBuilder()
            .build(title: "Failure!", message: error.localizedDescription, preferredStyle: .alert)
            .build(title: "Try again", style: .default, handler: {_ in
                self.input.send(.refreshWeatherFired)
            })
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Location

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Check if we're displaying other location than current
        if (viewModel.isShowingOtherLocation || locations.isEmpty) {
            return
        }
        
        let currentLocation = locations.first
        locationManager.stopUpdatingLocation()
        guard let longitude = currentLocation?.coordinate.longitude,
              let latitude = currentLocation?.coordinate.latitude else { return }
        
        let location = Location(latitude: latitude, longitude: longitude)
        
        input.send(.onCurrentLocationChanged(location: location))
    }
}
