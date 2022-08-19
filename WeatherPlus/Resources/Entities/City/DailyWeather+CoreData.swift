//
//  DailyWeather+CoreData.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation
import CoreData

@objc(DailyWeather)
public class DailyWeather: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var cityId: String
    @NSManaged public var conditionId: Int32
    @NSManaged public var dayTemp: String
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var time: Int32
    @NSManaged public var timezone: Int32
}

extension DailyWeather: Identifiable {
    
}

extension DailyWeather {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }
}
