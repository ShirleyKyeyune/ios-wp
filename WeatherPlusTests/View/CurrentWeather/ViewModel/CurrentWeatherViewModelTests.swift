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
        let expectation = self.expectation(description: "View status is updated 4 times when fetching Current Weather")
        expectation.expectedFulfillmentCount = 4

        let output = sut.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { event in
                events.append(event)
                expectation.fulfill()
            }.store(in: &cancellables)

        goToFetchCurrentWeatherFinished()

        XCTAssertTrue(mockWeatherService.isFetchCurrentWeatherCalled)
        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertEqual(events, [.showLoadingView(showLoading: true),
                                .showLoadingView(showLoading: true),
                                .fetchWeatherDidSucceed,
                                .showLoadingView(showLoading: false)])
    }

}

extension CurrentWeatherViewModelTests {
    private func goToFetchCurrentWeatherFinished() {
        mockWeatherService.currentWeatherData = StubGenerator().stubCurrentWeatherData()
        mockWeatherService.forecastData = StubGenerator().stubForecastWeatherData()
        mockWeatherService.setupFetchCurrentWeatherSuccess()
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

    func setupFetchCurrentWeatherSuccess() {
        guard let currentData = currentWeatherData,
              let forecastData = forecastData else {
            return
        }
        currentWeatherResult = Result.success(currentData).publisher.eraseToAnyPublisher()
        forecastResult = Result.success(forecastData).publisher.eraseToAnyPublisher()
    }

    func setupFetchCurrentWeatherFail(error: Error) {
        currentWeatherResult = Result.failure(error).publisher.eraseToAnyPublisher()
        forecastResult = Result.failure(error).publisher.eraseToAnyPublisher()
    }
}

class StubGenerator {

    func stubWeatherRequest() -> WeatherRequestType {
        return WeatherRequest(cityName: "Pretoria", latitude: -25.731340, longitude: 28.218370)
    }

    func stubCurrentWeatherData() -> CurrentWeatherData? {
        do {
            return try getTypeFromJSON(from: "currentweather")
        } catch {
            return nil
        }
    }

    func stubForecastWeatherData() -> WeatherData? {
        do {
            return try getTypeFromJSON(from: "forecast")
        } catch {
            return nil
        }
    }

    func getTypeFromJSON<T: Decodable>(from jsonFileName: String) throws -> T {
        let path = Bundle.main.path(forResource: jsonFileName, ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
