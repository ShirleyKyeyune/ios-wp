//
//  Weather.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation
import UIKit

enum WeatherCondition {
    case sunny
    case cloudy
    case rainy
}

struct WeatherStyle {
    let backgroundImage: String
    let title: String
    let colorHex: String
}

struct Location {
    let latitude: Double
    let longitude: Double
}

protocol CurrentWeatherType {
    var id: String { get }
    var dateTime: Int { get }
    var timezone: Int { get }
    var cityName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var conditionId: Int? { get }
    var temperature: Double { get }
    var temperatureMin: Double { get }
    var temperatureMax: Double { get }
    var feelsLike: Double { get }
    var description: String? { get }
    var lastUpdatedDateTime: String? { get }
}

struct CurrentWeatherModel: CurrentWeatherType, Identifiable, Hashable {
    var id = UUID().uuidString
    let latitude: Double
    let longitude: Double
    var conditionId: Int?
    var orderPosition: Int?
    var cityName: String
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let feelsLike: Double
    let dateTime: Int
    let timezone: Int
    var description: String?
    var lastUpdatedDateTime: String?
        
    
    init(weatherDTO: CurrentWeatherData, cityName: String) {
        self.cityName = cityName
        self.latitude = weatherDTO.coord.lat
        self.longitude = weatherDTO.coord.lon
        self.conditionId = weatherDTO.weather.first?.id
        self.temperature = weatherDTO.main.temp
        self.temperatureMin = weatherDTO.main.tempMin
        self.temperatureMax = weatherDTO.main.tempMax
        self.feelsLike = weatherDTO.main.feelsLike
        self.description = weatherDTO.weather.first?.weatherDescription
        self.dateTime = weatherDTO.dt
        self.timezone = weatherDTO.timezone
    }
    
    init(id: String,
         cityName: String,
         latitude: Double,
         longitude: Double,
         conditionId: Int,
         orderPosition: Int? = nil,
         temperature: Double,
         temperatureMin: Double,
         temperatureMax: Double,
         feelsLike: Double,
         description: String?,
         dateTime: Int,
         timezone: Int,
         lastUpdatedDateTime: String?
    ) {
        self.id = id
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.conditionId = conditionId
        self.orderPosition = orderPosition
        self.temperature = temperature
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
        self.feelsLike = feelsLike
        self.description = description
        self.dateTime = dateTime
        self.timezone = timezone
        self.lastUpdatedDateTime = lastUpdatedDateTime
    }

}

extension CurrentWeatherModel {
    public static func == (lhs: CurrentWeatherModel, rhs: CurrentWeatherModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude &&
        lhs.conditionId == rhs.conditionId &&
        lhs.cityName == rhs.cityName &&
        lhs.temperature == rhs.temperature &&
        lhs.temperatureMin == rhs.temperatureMin &&
        lhs.temperatureMax == rhs.temperatureMax &&
        lhs.description == rhs.description &&
        lhs.feelsLike == rhs.feelsLike &&
        lhs.dateTime == rhs.dateTime &&
        lhs.timezone == rhs.timezone &&
        lhs.lastUpdatedDateTime == rhs.lastUpdatedDateTime
    }
}

protocol DailyModelType {
    var id: String { get }
    var dateTime: Int { get }
    var conditionId: Int? { get }
    var temperature: Double { get }
    var temperatureMin: Double { get }
    var temperatureMax: Double { get }
    var timezone: Int { get }
}

struct DailyModel: DailyModelType, Identifiable, Hashable {
    var id: String = UUID().uuidString
    let dateTime: Int
    var conditionId: Int?
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let timezone: Int
    
    init(dailyDTO: Daily, coord: LatLon, timezone: Int) {
        self.conditionId = dailyDTO.weather.first?.id
        self.temperature = dailyDTO.main.temp
        self.temperatureMin = dailyDTO.main.tempMin
        self.temperatureMax = dailyDTO.main.tempMax
        self.dateTime = dailyDTO.dt
        self.timezone = timezone
    }
    
    init(id: String? = UUID().uuidString,
         dateTime: Int,
         conditionId: Int,
         temperature: Double,
         temperatureMin: Double,
         temperatureMax: Double,
         timezone: Int
    ) {
        self.id = id ?? UUID().uuidString
        self.conditionId = conditionId
        self.temperature = temperature
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperature
        self.dateTime = dateTime
        self.timezone = timezone
    }
}

extension DailyModel {
    public static func == (lhs: DailyModel, rhs: DailyModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.dateTime == rhs.dateTime &&
        lhs.timezone == rhs.timezone &&
        lhs.conditionId == rhs.conditionId &&
        lhs.temperature == rhs.temperature &&
        lhs.temperatureMin == rhs.temperatureMin &&
        lhs.temperatureMax == rhs.temperatureMax
    }
}
