//
//  WeatherCoreDataManager.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit
import CoreData

protocol DataStorageBasicProtocol {
    var getSavedItems: [CurrentWeatherType]? { get }
    func getSavedDailyWeather(cityId: String) -> [DailyModelType]
    func deleteItemWithID(_ id: String)
    func deleteItem(at index: Int)
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int)
    func addNewWeatherLocation(city: CurrentWeatherType)
    func addNewDailyWeather(_ cityId: String, dailyWeather: [DailyModelType])
}

protocol DataStorageType: DataStorageBasicProtocol {
    var managedContext: NSManagedObjectContext { get set }
}

class WeatherCoreDataManager: DataStorageType {
    
    // MARK: - Public properties
    
    internal var managedContext: NSManagedObjectContext
    
    var getSavedItems: [CurrentWeatherType]? {
        guard let savedCitiesEntities = getManagedCityObjects() else {
            return nil
        }
        
        var savedCities: [CurrentWeatherType] = []
        
        for savedCityEntity in savedCitiesEntities {
            guard let id = savedCityEntity.value(forKey: WPConstants.CoreData.City.id) as? String,
                  let name = savedCityEntity.value(forKey: WPConstants.CoreData.City.name) as? String,
                  let latitude = savedCityEntity.value(forKey: WPConstants.CoreData.City.latitude) as? Double,
                  let longitude = savedCityEntity.value(forKey: WPConstants.CoreData.City.longitude) as? Double else {
                return nil
            }
            
            let orderPosition = savedCityEntity.value(forKey: WPConstants.CoreData.City.orderPosition) as? Int
            let dateTime = savedCityEntity.value(forKey: WPConstants.CoreData.City.dateTime) as? Int
            let conditionId = savedCityEntity.value(forKey: WPConstants.CoreData.City.conditionId) as? Int
            let temperature = savedCityEntity.value(forKey: WPConstants.CoreData.City.temperature) as? Double
            let temperatureMin = savedCityEntity.value(forKey: WPConstants.CoreData.City.temperatureMin) as? Double
            let temperatureMax = savedCityEntity.value(forKey: WPConstants.CoreData.City.temperatureMax) as? Double
            let feelsLike = savedCityEntity.value(forKey: WPConstants.CoreData.City.feelsLike) as? Double
            let weatherConditionDescription = savedCityEntity.value(forKey: WPConstants.CoreData.City.weatherConditionDescription) as? String
            let lastUpdatedDateTime = savedCityEntity.value(forKey: WPConstants.CoreData.City.lastUpdatedDateTime) as? String
            let timezone = savedCityEntity.value(forKey: WPConstants.CoreData.City.timezone) as? Int
            
            let newSavedCity = CurrentWeatherModel(id: id,
                                                   cityName: name,
                                                   latitude: latitude,
                                                   longitude: longitude,
                                                   conditionId: conditionId ?? 800,
                                                   orderPosition: orderPosition ?? 0,
                                                   temperature: temperature ?? 0,
                                                   temperatureMin: temperatureMin ?? 0,
                                                   temperatureMax: temperatureMax ?? 0,
                                                   feelsLike: feelsLike ?? 0,
                                                   description: weatherConditionDescription,
                                                   dateTime: dateTime ?? 0,
                                                   timezone: timezone ?? 0,
                                                   lastUpdatedDateTime: lastUpdatedDateTime)
            savedCities.append(newSavedCity)
        }
        
        return savedCities
    }
    
    func getSavedDailyWeather(cityId: String) -> [DailyModelType] {
        guard let savedDailyWeatherEntities = getManagedDailyWeatherObjects(cityId: cityId) else {
            return []
        }
        
        var savedDailyWeather: [DailyModelType] = []
        
        for entity in savedDailyWeatherEntities {
            let id = entity.value(forKey: WPConstants.CoreData.DailyWeather.id) as? String
            let conditionId = entity.value(forKey: WPConstants.CoreData.DailyWeather.conditionId) as? Int
            let dayTemp = entity.value(forKey: WPConstants.CoreData.DailyWeather.dayTemp) as? Double
            let maxTemp = entity.value(forKey: WPConstants.CoreData.DailyWeather.maxTemp) as? Double
            let minTemp = entity.value(forKey: WPConstants.CoreData.DailyWeather.minTemp) as? Double
            let time = entity.value(forKey: WPConstants.CoreData.DailyWeather.time) as? Int
            let timezone = entity.value(forKey: WPConstants.CoreData.DailyWeather.timezone) as? Int
            
            let newSavedDailyWeather = DailyModel(id: id,
                                                  dateTime: time ?? 0,
                                                  conditionId: conditionId ?? 800,
                                                  temperature: dayTemp ?? 0,
                                                  temperatureMin: minTemp ?? 0,
                                                  temperatureMax: maxTemp ?? 0,
                                                  timezone: timezone ?? 0)
            savedDailyWeather.append(newSavedDailyWeather)
        }
        return savedDailyWeather
    }
    
    // MARK: - Construction
    
    init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
    }
    
    // MARK: - Public functions
    
    func deleteItemWithID(_ id: String) {
        guard let cityEntities = getManagedCityObjects() else {
            return
        }
        guard let item = cityEntities.first(where: { $0.id == id} ) else {
            return
        }
        managedContext.delete(item)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func deleteItem(at index: Int) {
        guard let cityEntities = getManagedCityObjects() else {
            return
        }
        
        managedContext.delete(cityEntities[index])
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func rearrangeItems(at firstIndex: Int, to secondIndex: Int) {
        guard var cityEntities = getManagedCityObjects() else {
            return
        }
        
        let mover = cityEntities[firstIndex]
        cityEntities.remove(at: firstIndex)
        cityEntities.insert(mover, at: secondIndex)
        
        for (index, entity) in cityEntities.enumerated() {
            entity.orderPosition = Int32(index)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not rearrange. \(error), \(error.userInfo)")
        }
    }
    
    func addNewWeatherLocation(city: CurrentWeatherType) {
        let entity = NSEntityDescription.entity(forEntityName: WPConstants.CoreData.City.entityName, in: managedContext)!
        let citySavingObject = NSManagedObject(entity: entity, insertInto: managedContext)
        citySavingObject.setValue(city.id, forKey: WPConstants.CoreData.City.id)
        citySavingObject.setValue(city.cityName, forKey: WPConstants.CoreData.City.name)
        citySavingObject.setValue(city.latitude, forKey: WPConstants.CoreData.City.latitude)
        citySavingObject.setValue(city.longitude, forKey: WPConstants.CoreData.City.longitude)
        citySavingObject.setValue(city.conditionId, forKey: WPConstants.CoreData.City.conditionId)
        citySavingObject.setValue(city.temperature, forKey: WPConstants.CoreData.City.temperature)
        citySavingObject.setValue(city.temperatureMin, forKey: WPConstants.CoreData.City.temperatureMin)
        citySavingObject.setValue(city.temperatureMax, forKey: WPConstants.CoreData.City.temperatureMax)
        citySavingObject.setValue(city.feelsLike, forKey: WPConstants.CoreData.City.feelsLike)
        citySavingObject.setValue(city.description, forKey: WPConstants.CoreData.City.weatherConditionDescription)
        citySavingObject.setValue(city.lastUpdatedDateTime, forKey: WPConstants.CoreData.City.lastUpdatedDateTime)
        
        let cityEntitiesCount = getManagedCityObjects()?.count ?? 0
        citySavingObject.setValue(cityEntitiesCount, forKey: WPConstants.CoreData.City.orderPosition)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addNewDailyWeather(_ cityId: String, dailyWeather: [DailyModelType]) {
        let entity = NSEntityDescription.entity(forEntityName: WPConstants.CoreData.DailyWeather.entityName, in: managedContext)!
        
        for weather in dailyWeather {
            let dailyWeatherSavingObject = NSManagedObject(entity: entity, insertInto: managedContext)
            dailyWeatherSavingObject.setValue(weather.id, forKey: WPConstants.CoreData.DailyWeather.id)
            dailyWeatherSavingObject.setValue(cityId, forKey: WPConstants.CoreData.DailyWeather.cityId)
            dailyWeatherSavingObject.setValue(weather.conditionId, forKey: WPConstants.CoreData.DailyWeather.conditionId)
            dailyWeatherSavingObject.setValue(weather.temperature, forKey: WPConstants.CoreData.DailyWeather.dayTemp)
            dailyWeatherSavingObject.setValue(weather.temperatureMax, forKey: WPConstants.CoreData.DailyWeather.maxTemp)
            dailyWeatherSavingObject.setValue(weather.temperatureMin, forKey: WPConstants.CoreData.DailyWeather.minTemp)
            dailyWeatherSavingObject.setValue(weather.dateTime, forKey: WPConstants.CoreData.DailyWeather.time)
            
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: WPConstants.CoreData.City.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete all items. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Private functions
    
    private func getManagedCityObjects() -> [City]? {
        // Fetch objects with order
        let fetchRequest = NSFetchRequest<City>(entityName: WPConstants.CoreData.City.entityName)
        let sortDescriptor = NSSortDescriptor(key: WPConstants.CoreData.City.orderPosition, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var entitiesToReturn: [City]?
        
        do {
            entitiesToReturn = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entitiesToReturn
    }
    
    private func getManagedDailyWeatherObjects(cityId: String) -> [DailyWeather]? {
        // Fetch objects with order
        let fetchRequest = NSFetchRequest<DailyWeather>(entityName: WPConstants.CoreData.DailyWeather.entityName)
        let sortDescriptor = NSSortDescriptor(key: WPConstants.CoreData.DailyWeather.time, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let cityIdPredicate = NSPredicate(
        format: "cityId == %@", cityId
        )
        
        fetchRequest.predicate = cityIdPredicate
        
        var entitiesToReturn: [DailyWeather]?
        
        do {
            entitiesToReturn = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entitiesToReturn
    }
}
