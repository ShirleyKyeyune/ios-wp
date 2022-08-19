//
//  DailyCellViewModel.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation
import Combine

protocol DailyCellType {
    var weekDay: String { get }
    var temperature: String { get }
    var conditionImage: String { get }
    var row: Int { get }
}

final class DailyCellViewModel: DailyCellType {
    
    private var dailyWeather: DailyModelType
    private var rowIndex: Int
    internal let weatherHelper: WeatherHelperType
    
    init(dailyWeather: DailyModelType,
         index: Int,
         weatherHelperType: WeatherHelperType = WeatherHelper()) {
        self.dailyWeather = dailyWeather
        self.rowIndex = index
        self.weatherHelper = weatherHelperType
    }
    
    var row: Int {
        return rowIndex
    }
    
    var weekDay: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dateTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: dailyWeather.timezone)
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
    var temperature: String {
        String(format: "%.0f°", dailyWeather.temperatureMax)
    }
    
    var conditionImage: String {
        let condition = dailyWeather.conditionId
        return weatherHelper.weatherIcon(from: condition)
    }
    
}
