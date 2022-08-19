//
//  LocationCellViewModel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation

protocol LocationCellType {
    var cityName: String { get }
    var temperature: String { get }
    var conditionImage: String { get }
    var lastUpdateTime: String { get }
    var conditionId: Int { get }
    var localTime: String { get }
    var lastUpateWithLocalTime: String { get }
    var row: Int { get }
}

final class LocationCellViewModel: LocationCellType {
    
    private var weather: CurrentWeatherType
    private var rowIndex: Int
    internal let weatherHelper: WeatherHelperType
    
    init(weather: CurrentWeatherType,
         index: Int,
         weatherHelperType: WeatherHelperType = WeatherHelper()) {
        self.weather = weather
        self.rowIndex = index
        self.weatherHelper = weatherHelperType
    }
    
    var row: Int {
        return rowIndex
    }
    
    var conditionId: Int {
        return weather.conditionId ?? 800
    }
    
    var localTime: String {
        let timeLabelTimeZone = TimeZone(secondsFromGMT: weather.timezone)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeLabelTimeZone
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date)
    }
    
    var lastUpateWithLocalTime: String {
        "Local time: \(localTime), Last update: \(lastUpdateTime)"
    }
    var cityName: String {
        return weather.cityName
    }
    
    var temperature: String {
        String(format: "%.0f°", weather.temperatureMax)
    }
    
    var conditionImage: String {
        let condition = weather.conditionId
        return weatherHelper.weatherIcon(from: condition)
    }
    
    var lastUpdateTime: String {
        return weather.lastUpdatedDateTime ?? "now"
    }
    
}
