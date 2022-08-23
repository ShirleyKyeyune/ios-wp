//
//  CurrentWeatherViewControllerTests.swift
//  WeatherPlusTests
//
//  Created by Shirley Kyeyune on 23/08/2022.
//

import XCTest
import SnapshotTesting
import UIKit

@testable import WeatherPlus

class CurrentWeatherViewControllerTests: XCTestCase {

    private var viewController: CurrentWeatherViewController!
    private var viewModel: CurrentWeatherViewModel!
    private var mockWeatherService: MockWeatherService!

    override func setUp() {
        mockWeatherService = MockWeatherService()
        viewModel = CurrentWeatherViewModel(weatherServiceType: mockWeatherService)
        let appComponents = AppComponents(UserDefaultsManager.ColorTheme.getCurrentColorTheme())
        viewController = CurrentWeatherViewController(appComponents: appComponents, viewModel: viewModel)
    }

    override func tearDown() {
        viewController = nil
        mockWeatherService = nil
        viewModel = nil
        super.tearDown()
    }

    func testCurrentWeatherView_OnViewDidLoad() {
        viewController.loadViewProgrammatically()
        assertValidSnapshot(matching: viewController)
    }

    func testCurrentWeatherView_ViewStateIs_fetchWeatherDidSucceed() {
        mockWeatherService.currentWeatherData = StubGenerator().stubCurrentWeatherData()
        mockWeatherService.forecastData = StubGenerator().stubForecastWeatherData()
        mockWeatherService.setupFetchCurrentWeatherSuccess()

        let expectation = self.expectation(description: "")

        viewController.loadViewProgrammatically()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.assertValidSnapshot(matching: self.viewController)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
