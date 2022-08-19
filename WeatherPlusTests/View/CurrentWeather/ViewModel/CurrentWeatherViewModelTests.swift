//
//  CurrentWeatherViewModelTests.swift
//  WeatherPlusTests
//
//  Created by Shirley Kyeyune on 19/08/2022.
//

import XCTest
import Combine
@testable import WeatherPlus

class CurrentWeatherViewModelTests: XCTestCase {

    var sut: CurrentWeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var input: PassthroughSubject<CurrentWeatherViewModel.InputEvent, Never>!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        input = .init()
        mockWeatherService = MockWeatherService()
        sut = CurrentWeatherViewModel(weatherServiceType: mockWeatherService)
    }

    override func tearDown() {
        sut = nil
        mockWeatherService = nil
        cancellables = []
        super.tearDown()
    }

    func testFetchCurrentWeather() {
        var events = [CurrentWeatherViewModel.OutputEvent]()
        let expectation1 = XCTestExpectation(description: "State is set to showLoadingView")
        let output = sut.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { event in
                events.append(event)
                
                let containsShowLoadingViewEvent = events.contains(.showLoadingView(showLoading: true))
                XCTAssertTrue(containsShowLoadingViewEvent)
                expectation1.fulfill()
            }.store(in: &cancellables)
        
        goToFetchCurrentWeatherFinished()
        
        XCTAssertTrue(mockWeatherService.isFetchCurrentWeatherCalled)
        
        wait(for: [expectation1], timeout: 20)
    }

}

extension CurrentWeatherViewModelTests {
    private func goToFetchCurrentWeatherFinished() {
        mockWeatherService.currentWeatherData = StubGenerator().stubCurrentWeatherData()
        mockWeatherService.forecastData = StubGenerator().stubForecastWeatherData()
        mockWeatherService.fetchCurrentWeatherSuccess()
        sut.handleFetchCurrentWeather(city: StubGenerator().stubWeatherRequest())
    }
}

class MockWeatherService: WeatherServiceType {
    var isFetchCurrentWeatherCalled = false
    var isFetchWeatherForecastCalled = false
    
    var currentWeatherData: CurrentWeatherData?
    var forecastData: WeatherData?
    var currentWeatherResult: AnyPublisher<CurrentWeatherData, Error>!
    var forecastResult: AnyPublisher<WeatherData, Error>!
    
    func fetchCurrentWeather(by city: WeatherRequestType) -> AnyPublisher<CurrentWeatherData, Error> {
        isFetchCurrentWeatherCalled = true
        return currentWeatherResult
    }
    
    func fetchWeatherForecast(by city: WeatherRequestType) -> AnyPublisher<WeatherData, Error> {
        isFetchWeatherForecastCalled = true
        return forecastResult
    }
    
    func fetchCurrentWeatherSuccess() {
        guard let currentData = currentWeatherData,
              let forecastData = forecastData else {
            return
        }
        currentWeatherResult = Result.success(currentData).publisher.eraseToAnyPublisher()
        forecastResult = Result.success(forecastData).publisher.eraseToAnyPublisher()
    }
    
    func fetchCurrentWeatherFail(error: Error) {
        currentWeatherResult = Result.failure(error).publisher.eraseToAnyPublisher()
        forecastResult = Result.failure(error).publisher.eraseToAnyPublisher()
    }
}

class StubGenerator {
    
    func stubWeatherRequest() -> WeatherRequestType {
        return WeatherRequest(cityName: "Pretoria", latitude: -25.731340, longitude: 28.218370)
    }
    
    func stubCurrentWeatherData() -> CurrentWeatherData {
        let path = Bundle.main.path(forResource: "currentweather", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let weather = try! decoder.decode(CurrentWeatherData.self, from: data)
        return weather
    }
    
    func stubForecastWeatherData() -> WeatherData {
        let path = Bundle.main.path(forResource: "forecast", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let weather = try! decoder.decode(WeatherData.self, from: data)
        return weather
    }
}
