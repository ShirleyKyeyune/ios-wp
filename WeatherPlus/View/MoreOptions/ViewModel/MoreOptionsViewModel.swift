//
//  MoreOptionsViewModel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Combine
import Foundation

protocol MoreOptionsViewType {
    var activeErrorStringValue: String { get }
    var getSavedItems: [CurrentWeatherType]? { get }
    var weatherForSavedCities: [CurrentWeatherType?] { get }
    var shouldAddNewCity: Bool { get }
    var savedCityTitles: [String] { get }
    func getSavedDailyWeather(cityId: String) -> [DailyModelType]
    
    func transform(input: AnyPublisher<MoreOptionsViewModel.InputEvent, Never>) -> AnyPublisher<MoreOptionsViewModel.OutputEvent, Never>
    
    func addNewItem(city: CurrentWeatherType)
    func deleteItemWithID(_ id: String)
    func deleteItem(at index: Int)
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int)
}

class MoreOptionsViewModel: MoreOptionsViewType {
    
    enum InputEvent {
        case viewWillAppear
        case viewDidAppear
        case didAddNewLocation
        case refreshWeatherFired
        case addEmptyItem
        case addNewItem(city: CurrentWeatherType)
        case deleteItemWithID(id: String)
        case deleteItem(index: Int)
        case insertItem(index: Int, mover: CurrentWeatherType?)
        case removeItem(index: Int)
        case rearrangeItems(firstIndex: Int, secondIndex: Int)
    }
    
    enum OutputEvent {
        case showAddNewCityView
        case didUpdateWeather(index: Int)
        case didFailFetchingWeatherWithError(error: Error)
    }
    
    private let weatherService: WeatherServiceType
    private let dataStorage: DataStorageType
    
    private let outputEvents: PassthroughSubject<OutputEvent, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var networkCancellables = Set<AnyCancellable>()
    
    private var localCities: [CurrentWeatherType] = []
    private var localCityWeatherList: [CurrentWeatherType?] = []
    private var activeErrorString: String?
    
    init(dataStorage: DataStorageType,
         weatherServiceType: WeatherServiceType = WeatherService()) {
        self.dataStorage = dataStorage
        self.weatherService = weatherServiceType
    }
    
    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<OutputEvent, Never> {
        input.sink { [weak self] event in
            guard let `self` = self else {
                return
            }
            switch event {
                case .viewWillAppear, .viewDidAppear, .refreshWeatherFired:
                    self.handleFetchWeather()
                case .didAddNewLocation:
                    self.handleFetchWeather()
                case .addNewItem(let city):
                    self.addNewItem(city: city)
                case .deleteItemWithID(let id):
                    self.deleteItemWithID(id)
                case .deleteItem(let index):
                    self.deleteItem(at: index)
                case .rearrangeItems(let firstIndex, let secondIndex):
                    self.rearrangeItems(at: firstIndex, to: secondIndex)
                case .insertItem(let index, let item):
                    self.insertItem(at: index, mover: item)
                case .removeItem(let index):
                    self.removeItem(at: index)
                case .addEmptyItem:
                    self.localCityWeatherList.append(nil)
            }
        }.store(in: &cancellables)
        return outputEvents.eraseToAnyPublisher()
    }
    
    var activeErrorStringValue: String {
        activeErrorString ?? "Something went wrong"
    }
    
    var shouldAddNewCity: Bool {
        weatherForSavedCities.isEmpty
    }
    
    var weatherForSavedCities: [CurrentWeatherType?] {
        localCityWeatherList
    }
    
    var savedCityTitles: [String] {
        localCityWeatherList.compactMap { $0?.cityName }
    }
    
    func handleFetchWeather() {
        guard let savedCities = dataStorage.getSavedItems else {
            self.outputEvents.send(.showAddNewCityView)
            return
        }
        
        self.localCities = savedCities
        localCityWeatherList.removeAll()
        
        // Add nils to display loading views
        for _ in 0..<savedCities.count {
            localCityWeatherList.append(nil)
        }
        
        for (i, city) in savedCities.enumerated() {
            let newCity = WeatherRequest(cityName: city.cityName,
                                         latitude: city.latitude,
                                         longitude: city.longitude)
            handleFetchCurrentWeather(by: newCity, at: i)
        }
    }
    
    private func handleFetchCurrentWeather(by city: WeatherRequestType, at index: Int) {
        weatherService.fetchCurrentWeather(by: city).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.localCityWeatherList.removeAll()
                self?.outputEvents.send(.didFailFetchingWeatherWithError(error: error))
                self?.networkCancellables.removeAll()
            }
        } receiveValue: { [weak self] currentWeather in
            guard let `self` = self else {
                return
            }
            self.localCityWeatherList[index] = CurrentWeatherModel(weatherDTO: currentWeather, cityName: city.cityName)
            
            self.outputEvents.send(.didUpdateWeather(index: index))
        }.store(in: &networkCancellables)
    }
    
    var getSavedItems: [CurrentWeatherType]? {
        return dataStorage.getSavedItems
    }
    
    func addNewItem(city: CurrentWeatherType) {
        dataStorage.addNewWeatherLocation(city: city)
    }
    
    func deleteItemWithID(_ id: String) {
        dataStorage.deleteItemWithID(id)
    }
    
    func deleteItem(at index: Int) {
        dataStorage.deleteItem(at: index)
        self.localCityWeatherList.remove(at: index)
    }
    
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int) {
        dataStorage.rearrangeItems(at: firstIndex, to: secondIndex)
    }
    
    func insertItem(at index: Int, mover: CurrentWeatherType?) {
        self.localCityWeatherList.insert(mover, at: index)
    }
    
    func removeItem(at index: Int) {
        self.localCityWeatherList.remove(at: index)
    }
    
    func getSavedDailyWeather(cityId: String) -> [DailyModelType] {
        self.dataStorage.getSavedDailyWeather(cityId: cityId)
    }
    
}
