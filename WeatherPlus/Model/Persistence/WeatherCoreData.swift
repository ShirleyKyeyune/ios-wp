//
//  WeatherCoreData.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 13/08/2022.
//

import Foundation
import MapKit

protocol WeatherRequestType {
    var cityName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
}

struct WeatherRequest: WeatherRequestType, Codable {
    let cityName: String
    let latitude: Double
    let longitude: Double
}


class WeatherMapLocation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    static func from(weather: CurrentWeatherType) -> WeatherMapLocation {
        let weatherHelper = WeatherHelper()
        let condition = weatherHelper.weatherCondition(weather.conditionId)
        let weatherConditionName = weatherHelper.weatherStyle(from: condition).title
        let temperature = weatherHelper.formatTemperature(temperature: weather.temperature)
        let title = weather.cityName + " ~ " + temperature + "  " + weatherConditionName
        let description = weather.description ?? ""
        let locationName = "Lat:\(weather.latitude), Lon:\(weather.longitude)  \(description)"
        return WeatherMapLocation(title: title,
                                  locationName: locationName,
                                  discipline: weatherHelper.formatTemperature(temperature: weather.temperature),
                                  coordinate: CLLocationCoordinate2D(latitude:
                                                                        weather.latitude,
                                                                     longitude: weather.longitude)
        )
    }
}
