//
//  NetworkManager.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation
import Combine

protocol CustomErrorType: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: CustomErrorType {
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String = "Error", description: String, code: Int) {
        self.title = title
        self._description = description
        self.code = code
    }
}

protocol WeatherServiceType {
    func fetchCurrentWeather(by city: WeatherRequestType) -> AnyPublisher<CurrentWeatherData, Error>
    func fetchWeatherForecast(by city: WeatherRequestType) -> AnyPublisher<WeatherData, Error>
}

struct WeatherService: WeatherServiceType {

    // MARK: - Fetching weather data

    func fetchCurrentWeather(by city: WeatherRequestType) -> AnyPublisher<CurrentWeatherData, Error> {
        let baseURL = WPConstants.Network.currentBaseURL
        let lat = city.latitude
        let lon = city.longitude
        let appid = WPConstants.Network.apiKey
        let units = UserDefaultsManager.UnitData.get()
        
        let urlString = "\(baseURL)lat=\(lat)&lon=\(lon)&appid=\(appid)&units=\(units)&exclude=\(WPConstants.Network.minutely)"
        
        guard let url = encodeUrlString(urlString: urlString) else {
            let urlError = CustomError(description: "Malformed URL", code: 404)
            return Fail(error: urlError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: CurrentWeatherData.self, decoder: JSONDecoder())
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherForecast(by city: WeatherRequestType) -> AnyPublisher<WeatherData, Error> {
        let baseURL = WPConstants.Network.forecastBaseURL
        let lat = city.latitude
        let lon = city.longitude
        let appid = WPConstants.Network.apiKey
        let units = UserDefaultsManager.UnitData.get()
        
        let urlString = "\(baseURL)lat=\(lat)&lon=\(lon)&appid=\(appid)&units=\(units)&exclude=\(WPConstants.Network.minutely)"
        
        guard let url = encodeUrlString(urlString: urlString) else {
            let urlError = CustomError(description: "Malformed URL", code: 404)
            return Fail(error: urlError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }.map({ $0.data })
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    // MARK: - Private functions

    private func encodeUrlString(urlString: String) -> URL? {
        // Getting rid of any spaces in the URL string
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        return URL(string: encodedURLString)
    }
}
