//
//  AddWeatherLocationViewModel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation
import Combine

protocol AddWeatherLocationViewType {
    var shouldAddNewLocationValue: Bool { get }
    var isCurrentLocationUpdatedValue: Bool { get }
    var savedCityTitles: [String] { get }
    var currentLocationValue: Location { get }
    
    func transform(input: AnyPublisher<AddWeatherLocationViewModel.InputEvent, Never>) -> AnyPublisher<AddWeatherLocationViewModel.OutputEvent, Never>
}

class AddWeatherLocationViewModel: AddWeatherLocationViewType {
    enum InputEvent {
        case tryToAddCurrentLocation
        case didChoseCity(title: String, subtitle: String)
        case onCurrentLocationChanged(location: Location)
        case didUpdateLocation(location: Location)
    }
    
    enum OutputEvent {
        case fetchWeatherDidFail(error: Error)
        case fetchLocationCityNameDidSucceed(weatherLocation: CurrentWeatherType)
        case searchCityDidSucceed(weatherLocation: CurrentWeatherType)
        case loadingView(isHidden: Bool)
    }
    
    private let locationService: LocationServiceType
    private let weatherHelper: WeatherHelperType
    
    private let outputEvents: PassthroughSubject<OutputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentLocation: Location = Location(latitude: 0, longitude: 0)
    private var cityTitles: [String]
    private var shouldAddNewLocation = false
    private var isCurrentLocationUpdated = false
    
    init(savedCityTitles: [String],
         locationServiceType: LocationService = LocationService(),
         weatherHelperType: WeatherHelperType = WeatherHelper()) {
        self.cityTitles = savedCityTitles
        self.locationService = locationServiceType
        self.weatherHelper = weatherHelperType
    }
    
    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<OutputEvent, Never> {
        input.sink { [weak self] event in
            switch event {
                case .didChoseCity(let title, let subtitle):
                    self?.handleSearchLocation(title, subtitle)
                case .onCurrentLocationChanged(let location):
                    self?.handleFetchCurrentCityName(newLocation: location)
                case .tryToAddCurrentLocation:
                    self?.shouldAddNewLocation = true
                case .didUpdateLocation(let location):
                    self?.handleDidUpdateLocation(location: location)
            }
        }.store(in: &cancellables)
        return outputEvents.eraseToAnyPublisher()
    }
    
    var currentLocationValue: Location {
        currentLocation
    }
    
    var isCurrentLocationUpdatedValue: Bool {
        isCurrentLocationUpdated
    }
    
    var shouldAddNewLocationValue: Bool {
        shouldAddNewLocation
    }
    
    var savedCityTitles: [String] {
        cityTitles
    }
    
    private func handleFetchCurrentCityName(newLocation: Location) {
        outputEvents.send(.loadingView(isHidden: false))
        
        locationService.fetchCurrentCityName(by: newLocation).sink { [weak self] completion in
            self?.outputEvents.send(.loadingView(isHidden: true))
            if case .failure(let error) = completion {
                self?.outputEvents.send(.fetchWeatherDidFail(error: error))
            }
        } receiveValue: { [weak self] cityName in
            guard let `self` = self else {
                return
            }
            self.shouldAddNewLocation = false
            let newCityRequest = WeatherRequest(cityName: cityName,
                                         latitude: newLocation.latitude,
                                         longitude: newLocation.longitude)
            self.outputEvents.send(.fetchLocationCityNameDidSucceed(weatherLocation: self.generateWeatherLocation(weatherRequest: newCityRequest)))
        }.store(in: &cancellables)
    }
    
    private func handleSearchLocation(_ title: String, _ subtitle: String) {
        outputEvents.send(.loadingView(isHidden: false))
        
        locationService.searchLocationCoordinates(title: title, subtitle: subtitle).sink { [weak self] completion in
            self?.outputEvents.send(.loadingView(isHidden: true))
            if case .failure(let error) = completion {
                self?.outputEvents.send(.fetchWeatherDidFail(error: error))
            }
        } receiveValue: { [weak self] weatherRequest in
            guard let `self` = self else {
                return
            }
            guard let weatherRequest =  weatherRequest else {
                let error = CustomError(description: "Failed to Search Coordinates", code: 303)
                self.outputEvents.send(.fetchWeatherDidFail(error: error))
                return
            }
            self.outputEvents.send(.searchCityDidSucceed(weatherLocation: self.generateWeatherLocation(weatherRequest: weatherRequest)))
        }.store(in: &cancellables)
    }
    
    private func handleDidUpdateLocation(location: Location) {
        currentLocation = location
        isCurrentLocationUpdated = true
        if shouldAddNewLocation {
            addCurrentLocationWeather()
        }
    }
    
    private func addCurrentLocationWeather() {
        guard isCurrentLocationUpdated else {
            return
        }
        shouldAddNewLocation = false
        handleFetchCurrentCityName(newLocation: currentLocation)
    }
    
    private func generateWeatherLocation(weatherRequest: WeatherRequestType) -> CurrentWeatherType {
        // Today in milliseconds
        let dateTime = Int(Date().timeIntervalSince1970) * 1000
        let timezone = TimeZone.current.secondsFromGMT()
        let currentTime = weatherHelper.currentDateFormatted()
        return CurrentWeatherModel(id: UUID().uuidString,
                            cityName: weatherRequest.cityName,
                            latitude: weatherRequest.latitude,
                            longitude: weatherRequest.longitude,
                            conditionId: 800,
                            temperature: 0,
                            temperatureMin: 0,
                            temperatureMax: 0,
                            feelsLike: 0,
                            description: nil,
                            dateTime: dateTime,
                            timezone: timezone,
                            lastUpdatedDateTime: currentTime)
    }
}
