//
//  AddWeatherLocationViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit
import MapKit
import Combine

class AddWeatherLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddWeatherLocationDelegate?
    
    var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    private var viewModel: AddWeatherLocationViewType
    private let input: PassthroughSubject<AddWeatherLocationViewModel.InputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Private properties
    
    private lazy var addCityView = AddWeatherLocationView(colorThemeComponent: colorThemeComponent)
    private let colorThemeComponent: ColorThemeProtocol
    
    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol,
         viewModel: AddWeatherLocationViewType) {
        self.colorThemeComponent = colorThemeComponent
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.delegate = self
        searchCompleter.delegate = self
        
        locationManager.startUpdatingLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addCityView
        addCityView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    // MARK: - Private functions
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let `self` = self else {
                    return
                }
                switch event {
                    
                    case .fetchWeatherDidFail(let error):
                        self.didFinishedWithError(error: error)
                    case .fetchLocationCityNameDidSucceed(let weatherLocation):
                        self.addCity(city: weatherLocation)
                    case .searchCityDidSucceed(let weatherLocation):
                        self.addCity(city: weatherLocation)
                    case .loadingView(let isHidden):
                        self.addCityView.loadingView(isHidden)
                }
            }.store(in: &cancellables)
        
    }
    
    private func didFinishedWithError(error: Error?) {
        delegate?.didFailAddingNewCityWithError(error: error)
    }
    
    private func addCity(city: CurrentWeatherType) {
        delegate?.addNewWeatherLocation(city: city)
        
        dismiss(animated: true) {
            self.delegate?.didAddNewCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension AddWeatherLocationViewController: AddWeatherLocationViewDelegate {
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func didChoseCity(title: String, subtitle: String) {
        input.send(.didChoseCity(title: title, subtitle: subtitle))
    }
    
    func tryToAddCurrentLocation() {
        locationManager.requestAlwaysAuthorization()
        
        input.send(.tryToAddCurrentLocation)
        addCurrentLocationWeather()
    }
    
    func addCurrentLocationWeather() {
        guard viewModel.isCurrentLocationUpdatedValue else {
            return
        }
        input.send(.onCurrentLocationChanged(location: viewModel.currentLocationValue))
    }
}

extension AddWeatherLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchResults = completer.results.filter { result in
            // Getting rid of any results that contain digits
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil || (result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) {
                return false
            }
            
            for savedCityTitle in viewModel.savedCityTitles {
                if result.title == savedCityTitle {
                    return false
                }
            }
            
            return true
        }
        
        addCityView.updateSearchResults(searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let alert = AlertViewBuilder()
            .build(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
            .build(title: "Ok", style: .default, handler: nil)
            .content
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AddWeatherLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        let currentLocation = Location(latitude: locationValue.latitude,
                                   longitude: locationValue.longitude)
        input.send(.didUpdateLocation(location: currentLocation))
        
    }
}
