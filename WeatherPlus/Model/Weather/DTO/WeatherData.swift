//
//  WeatherData.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation

struct CurrentWeatherData: Codable {
    let dt: Int // Current time
    let timezone: Int
    let coord: LatLon
    let weather: [Weather]
    let main: MainTemp
}

struct WeatherData: Codable {
    let list: [Daily]
    let city: CityData
}

struct Daily: Codable {
    let dt: Int
    let main: MainTemp
    let weather: [Weather]
    let pop: Double
}

struct CityData: Codable {
    let coord: LatLon
    let timezone: Int
}

struct LatLon: Codable {
    let lat: Double
    let lon: Double
}

struct Weather: Codable {
    let id: Int
    let main, weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
    }
}

struct MainTemp: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
