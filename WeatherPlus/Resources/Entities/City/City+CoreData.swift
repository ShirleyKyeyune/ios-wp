//
//  City+CoreData.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var name: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var orderPosition: Int32
    @NSManaged public var dateTime: Int32
    @NSManaged public var timezone: Int32
    @NSManaged public var conditionId: Int32
    @NSManaged public var temperature: Double
    @NSManaged public var temperatureMin: Double
    @NSManaged public var temperatureMax: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var weatherConditionDescription: String
    @NSManaged public var lastUpdatedDateTime: String
}

extension City: Identifiable {
    
}

extension City {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }
}
