//
//  CurrentWeatherViewModel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 17/08/2022.
//

import Foundation
import Combine

protocol CurrentWeatherViewType {
    var isShowingOtherLocation: Bool { get }
    var cityTitle: String { get }
    var temperatureString: String { get }
    var minTemperatureString: String { get }
    var maxTemperatureString: String { get }
    var weatherCondition: WeatherCondition { get }
    var forecast5days: [DailyModelType] { get }
    var weatherStyle: WeatherStyle { get }

    func transform(input: AnyPublisher<CurrentWeatherViewModel.InputEvent, Never>) -> AnyPublisher<CurrentWeatherViewModel.OutputEvent, Never>

    func handleFetchWeather()

    func handleFetchCurrentCityName(newLocation: Location)

    func handleFetchCurrentWeather(city: WeatherRequestType)

    func handleFetchWeatherForecast(city: WeatherRequestType)

    func filterFiveDayWeatherData(dailyWeather: [DailyModelType]) -> [DailyModelType]

    func updateWeatherConditionStyles()
}

class CurrentWeatherViewModel: CurrentWeatherViewType {

    enum InputEvent {
        case viewDidAppear
        case onCurrentLocationChanged(location: Location)
        case refreshWeatherFired

        static func == (lhs: InputEvent, rhs: InputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.viewDidAppear, .viewDidAppear): return true
            case (.onCurrentLocationChanged, .onCurrentLocationChanged): return true
            case (.refreshWeatherFired, .refreshWeatherFired): return true
            default: return false
            }
        }
    }

    enum OutputEvent: Equatable {
        case fetchWeatherDidFail(error: Error)
        case fetchWeatherDidSucceed
        case showLoadingView(showLoading: Bool)

        static func == (lhs: OutputEvent, rhs: OutputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.fetchWeatherDidFail, .fetchWeatherDidFail): return true
            case (.fetchWeatherDidSucceed, .fetchWeatherDidSucceed): return true
            case (.showLoadingView, .showLoadingView): return true
            default: return false
            }
        }
    }

    private let weatherService: WeatherServiceType
    private let locationService: LocationServiceType
    private let weatherHelper: WeatherHelperType

    private let outputEvents: PassthroughSubject<OutputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private var weatherConditionStyle: WeatherStyle?

    private var currentWeather: CurrentWeatherType?
    private var weatherForecast: [DailyModelType]?

    init(
        weatherServiceType: WeatherServiceType = WeatherService(),
        locationServiceType: LocationService = LocationService(),
        weatherHelperType: WeatherHelperType = WeatherHelper(),
        currentWeather: CurrentWeatherType? = nil
    ) {
        self.weatherService = weatherServiceType
        self.locationService = locationServiceType
        self.weatherHelper = weatherHelperType
        self.currentWeather = currentWeather
    }

    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<OutputEvent, Never> {
        input.sink { [weak self] event in
            switch event {
            case .viewDidAppear, .refreshWeatherFired:
            self?.handleFetchWeather()
            case .onCurrentLocationChanged(let location):
            self?.handleFetchCurrentCityName(newLocation: location)
            }
        }
        .store(in: &cancellables)
        return outputEvents.eraseToAnyPublisher()
    }

    func handleFetchWeather() {
        if let currentWeather = currentWeather {
            let newCity = WeatherRequest(
                cityName: currentWeather.cityName,
                latitude: currentWeather.latitude,
                longitude: currentWeather.longitude)
            handleFetchCurrentWeather(city: newCity)
        } else {
            outputEvents.send(.showLoadingView(showLoading: true))
        }
    }

    func handleFetchCurrentCityName(newLocation: Location) {
        outputEvents.send(.showLoadingView(showLoading: true))

        locationService
            .fetchCurrentCityName(by: newLocation)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                self?.outputEvents.send(.fetchWeatherDidFail(error: error))
                }
            } receiveValue: { [weak self] cityName in
                let newCity = WeatherRequest(
                    cityName: cityName,
                    latitude: newLocation.latitude,
                    longitude: newLocation.longitude)
                self?.handleFetchCurrentWeather(city: newCity)
            }
            .store(in: &cancellables)
    }

    func handleFetchCurrentWeather(city: WeatherRequestType) {
        outputEvents.send(.showLoadingView(showLoading: true))
        weatherService.fetchCurrentWeather(by: city)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputEvents.send(.fetchWeatherDidFail(error: error))
                    self?.cancellables.removeAll()
                }
            } receiveValue: { [weak self] currentWeather in
                self?.currentWeather = CurrentWeatherModel(weatherDTO: currentWeather, cityName: city.cityName)

                self?.handleFetchWeatherForecast(city: city)
            }
            .store(in: &cancellables)
    }

    func handleFetchWeatherForecast(city: WeatherRequestType) {
        outputEvents.send(.showLoadingView(showLoading: true))
        weatherService.fetchWeatherForecast(by: city)
            .sink { [weak self] completion in
                self?.outputEvents.send(.showLoadingView(showLoading: false))
                if case .failure(let error) = completion {
                    self?.outputEvents.send(.fetchWeatherDidFail(error: error))
                }
            } receiveValue: { [weak self] forecast in
                guard let `self` = self else {
                    return
                }

                let dailyList = forecast.list.map {
                    DailyModel(dailyDTO: $0, coord: forecast.city.coord, timezone: forecast.city.timezone)
                }

                self.weatherForecast = self.filterFiveDayWeatherData(dailyWeather: dailyList)
                self.updateWeatherConditionStyles()
                self.outputEvents.send(.fetchWeatherDidSucceed)
            }
            .store(in: &cancellables)
    }

    func filterFiveDayWeatherData(dailyWeather: [DailyModelType]) -> [DailyModelType] {
        var newList: [DailyModelType] = []
        var counter = 0
        while counter < dailyWeather.count {
            newList.append(dailyWeather[counter])
            counter += 8
        }

        return newList
    }

    var isShowingOtherLocation: Bool {
        currentWeather != nil
    }

    var cityTitle: String {
        return currentWeather?.cityName ?? "Current Location"
    }

    var temperatureString: String {
        let temperature = currentWeather?.temperature ?? 0
        return weatherHelper.formatTemperature(temperature: temperature)
    }

    var minTemperatureString: String {
        let temperature = currentWeather?.temperatureMin ?? 0
        return weatherHelper.formatTemperature(temperature: temperature)
    }

    var maxTemperatureString: String {
        let temperature = currentWeather?.temperatureMax ?? 0
        return weatherHelper.formatTemperature(temperature: temperature)
    }

    var weatherCondition: WeatherCondition {
        weatherHelper.weatherCondition(currentWeather?.conditionId)
    }

    var weatherStyle: WeatherStyle {
        guard let style = weatherConditionStyle else {
            return WeatherStyle(
                backgroundImage: WPConstants.ImageName.sunnyBackground,
                title: WPConstants.WeatherDescription.sunny,
                colorHex: WPConstants.WeatherColor.sunny)
        }
        return style
    }

    func updateWeatherConditionStyles() {
        weatherConditionStyle = weatherHelper.weatherStyle(from: weatherCondition)
    }

    var forecast5days: [DailyModelType] {
        weatherForecast ?? []
    }
}
