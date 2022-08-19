//
//  WeatherHelper.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation

protocol WeatherHelperType {
    func currentDateFormatted() -> String
    func formatTemperature(temperature: Double) -> String
    func weatherCondition(_ conditionId: Int?) -> WeatherCondition
    func weatherStyle(from weatherCondition: WeatherCondition) -> WeatherStyle
    func weatherIcon(from conditionId: Int?) -> String
    func weatherIcon(from weatherCondition: WeatherCondition) -> String
}

class WeatherHelper: WeatherHelperType {
    
    func currentDateFormatted() -> String {
        let time = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM d, h:mm a"
        return format.string(from: time)
    }
    
    func formatTemperature(temperature: Double) -> String {
        return String(format: "%.0f°", temperature)
    }
    
    /// Reference: https://openweathermap.org/weather-conditions
    func weatherCondition(_ conditionId: Int?) -> WeatherCondition {
        guard let conditionId = conditionId else {
            return .sunny
        }
        switch conditionId {
            case 200...232:
                return .cloudy
            case 300...321:
                return .rainy
            case 500...531:
                return .rainy
            case 600...622:
                return .cloudy
            case 701...781:
                return .cloudy
            case 800:
                return .sunny
            case 801...804:
                return .cloudy
            default:
                return .cloudy
        }
    }
    
    func weatherStyle(from weatherCondition: WeatherCondition) -> WeatherStyle {
        var weatherConditionBgImage: String
        var weatherConditionTitle: String
        var weatherConditionColor: String
        
        switch weatherCondition {
            case .sunny:
                weatherConditionBgImage = WPConstants.ImageName.sunnyBackground
                weatherConditionTitle = WPConstants.WeatherDescription.sunny
                weatherConditionColor = WPConstants.WeatherColor.sunny
                
            case .cloudy:
                weatherConditionBgImage = WPConstants.ImageName.cloudyBackground
                weatherConditionTitle = WPConstants.WeatherDescription.cloudy
                weatherConditionColor = WPConstants.WeatherColor.cloudy
                
            case .rainy:
                weatherConditionBgImage = WPConstants.ImageName.rainyBackground
                weatherConditionTitle = WPConstants.WeatherDescription.rainy
                weatherConditionColor = WPConstants.WeatherColor.rainy
        }
        
        return WeatherStyle(backgroundImage: weatherConditionBgImage, title: weatherConditionTitle, colorHex: weatherConditionColor)
    }
    
    func weatherIcon(from weatherCondition: WeatherCondition) -> String {
        switch weatherCondition {
            case .sunny:
                return WPConstants.ImageName.clearIcon
            case .cloudy:
                return WPConstants.ImageName.partlySunnyIcon
            case .rainy:
                return WPConstants.ImageName.rainIcon
        }
    }
    
    func weatherIcon(from conditionId: Int?) -> String {
        let weatherCondition = weatherCondition(conditionId)
        return weatherIcon(from: weatherCondition)
    }
}
