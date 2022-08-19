//
//  MoreOptionsViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit
import Combine
import CoreData

protocol MoreOptionsDelegate: ReloadColorThemeProtocol {
    func fetchWeatherData()
}

protocol AddWeatherLocationProtocol {
    func didAddNewCity()
    func didFailAddingNewCityWithError(error: Error?)
}

protocol AddWeatherLocationDelegate: AddWeatherLocationProtocol, DataStorageBasicProtocol, AnyObject {}

class MoreOptionsViewController: UIViewController, MoreOptionsDelegate {
    
    // MARK: - Private properties
    
    private var viewModel: MoreOptionsViewType
    private let input: PassthroughSubject<MoreOptionsViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private let fadeTransitionAnimator = FadeTransitionAnimator()
    private var tableView: UITableView?
    private lazy var tableViewDelegate: MoreOptionsTableViewDelegate = {
        let tableViewDelegate = MoreOptionsTableViewDelegate(colorThemeComponent: appComponents)
        tableViewDelegate.viewController = self
        return tableViewDelegate
    }()
    
    private lazy var mainManuView = MoreOptionsView(colorThemeComponent: appComponents,
                                                 tableViewDataSourceDelegate: tableViewDelegate)
    // MARK: - Public properties
    
    var appComponents: AppComponents
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return appComponents.colorTheme.moreOptions.isStatusBarDark ? .darkContent : .lightContent
    }
    
    // MARK: - Lifecycle
    
    init(appComponents: AppComponents, managedContext: NSManagedObjectContext) {
        self.appComponents = appComponents
        let storageManager = WeatherCoreDataManager(managedContext: managedContext)
        self.viewModel = MoreOptionsViewModel(dataStorage: storageManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainManuView
        mainManuView.viewController = self
        tableView = mainManuView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        input.send(.viewWillAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Functions
    func fetchWeatherData() {
        input.send(.refreshWeatherFired)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let `self` = self else {
                    return
                }
                switch event {
                    case .showAddNewCityView:
                        self.showAddCityVC()
                    case .didUpdateWeather(let index):
                        self.didUpdateWeather(at: index)
                    case .didFailFetchingWeatherWithError(let error):
                        self.didFailWithError(error: error)
                }
            }.store(in: &cancellables)
        
    }
    
    
    func showAddCityVC() {
        let destinationViewModel = AddWeatherLocationViewModel(savedCityTitles: viewModel.savedCityTitles)
        let destinationVC = AddWeatherLocationViewController(colorThemeComponent: appComponents, viewModel: destinationViewModel)
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }
    
    func showDetailViewVC() {
        guard let displayWeatherIndex = self.tableView?.indexPathForSelectedRow?.row,
              let selectedWeatherData = viewModel.weatherForSavedCities[displayWeatherIndex] else {
            let alert = AlertViewBuilder()
                .build(title: "Oops", message: viewModel.activeErrorStringValue, preferredStyle: .alert)
                .build(title: "Ok", style: .default, handler: nil)
                .content
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        let currentViewModel = CurrentWeatherViewModel(currentWeather: selectedWeatherData)
        let destinationVC = CurrentWeatherViewController(appComponents: appComponents, viewModel: currentViewModel)
        
        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.navigationBar.barStyle = .black
        
        self.dismiss(animated: false, completion: {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navigationController)
        })
    }
    
    func showSettingsViewController() {
        let destinationVC = SettingsViewController(colorThemeComponent: appComponents)
        destinationVC.moreOptionsDelegate = self

        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    func showMapViewController() {
        let weatherList: [WeatherMapLocation]  = viewModel.weatherForSavedCities.compactMap({
            guard let weatherModel = $0 else {
                return nil
            }
            return WeatherMapLocation.from(weather: weatherModel)
        })
        
        let destinationVC = WeatherMapViewController(colorThemeComponent: appComponents,
                                                     savedCityTitles: weatherList)
            navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func didUpdateWeather(at position: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: position, section: 0)
            self.tableView?.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func didFailWithError(error: Error) {
        let removeEmptyCells: ((UIAlertAction) -> (Void)) = { _ in
            self.tableView?.reloadData()
        }
        
        DispatchQueue.main.async {
            let alert = AlertViewBuilder()
                .build(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                .build(title: "Ok", style: .default, handler: removeEmptyCells)
                .content
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func reloadColorTheme() {
        mainManuView.reloadViews()
        tableView?.reloadData()
    }
}

extension MoreOptionsViewController: AddWeatherLocationDelegate {
    func getSavedDailyWeather(cityId: String) -> [DailyModelType] {
        viewModel.getSavedDailyWeather(cityId: cityId)
    }
    
    func addNewDailyWeather(_ cityId: String, dailyWeather: [DailyModelType]) {
        
    }
    
    func addNewWeatherLocation(city: CurrentWeatherType) {
        input.send(.addNewItem(city: city))
    }
    
    func didAddNewCity() {
        input.send(.addEmptyItem)
        tableView?.insertRows(at: [IndexPath(row: self.viewModel.weatherForSavedCities.count - 1, section: 0)], with: .automatic)
        
        input.send(.didAddNewLocation)
    }
    
    func didFailAddingNewCityWithError(error: Error?) {
        let errorMessage: String
        
        if let strongError = error {
            errorMessage = strongError.localizedDescription
        } else {
            errorMessage = "Something went wrong :<"
        }
        
        let alert = AlertViewBuilder()
            .build(title: "Oops", message: errorMessage, preferredStyle: .alert)
            .build(title: "Ok", style: .default, handler: nil)
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MoreOptionsViewController: MoreOptionsTableViewDataSourceDelegate {
    var displayWeather: [CurrentWeatherType?] {
        viewModel.weatherForSavedCities
    }
    
    var getSavedItems: [CurrentWeatherType]? {
        viewModel.getSavedItems
    }
    
    func didSelectRow() {
        showDetailViewVC()
    }
    
    func deleteItemWithID(_ id: String) {
        input.send(.deleteItemWithID(id: id))
    }
    
    func insertItem(at index: Int, item: CurrentWeatherType?) {
        input.send(.insertItem(index: index, mover: item))
    }
    
    func removeItem(at index: Int) {
        input.send(.removeItem(index: index))
    }
    
    func deleteItem(at index: Int) {
        input.send(.deleteItem(index: index))
    }
    
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int) {
        input.send(.rearrangeItems(firstIndex: firstIndex, secondIndex: secondIndex))
    }
}

// MARK: - Transition animation

extension MoreOptionsViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fadeTransitionAnimator
    }
}
