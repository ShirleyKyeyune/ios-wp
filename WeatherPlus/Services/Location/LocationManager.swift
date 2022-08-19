//
//  LocationManager.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 18/08/2022.
//

import Foundation
import Combine
import CoreLocation
import MapKit

protocol LocationServiceType {
    func fetchCurrentCityName(by location: Location) -> AnyPublisher<String, Never>
    func searchLocationCoordinates(title: String, subtitle: String) -> AnyPublisher<WeatherRequestType?, Error>
}

struct LocationService: LocationServiceType {
    
    func fetchCurrentCityName(by location: Location) -> AnyPublisher<String, Never> {
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        return Future<[CLPlacemark]?, Never> { promise in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    promise(.success(placemarks))
                }
        }
        .map({ cityName(placemarks: $0) })
        .eraseToAnyPublisher()
    }
    
    func searchLocationCoordinates(title: String, subtitle: String) -> AnyPublisher<WeatherRequestType?, Error> {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = title + " " + subtitle
        
        return Future<MKLocalSearch.Response?, Error> { promise in
            MKLocalSearch(request: searchRequest).start { response, error in
                guard let response = response else {
                    let newError = error ?? CustomError(description: "Search failed", code: 404)
                    promise(.failure(newError))
                    return
                }
                promise(.success(response))
            }
        }
        .map({ weatherRequest(from: $0, title: title) })
        .eraseToAnyPublisher()
    }
    
    private func cityName(placemarks: [CLPlacemark]?) -> String {
        guard let placemark = placemarks?.first else {
            return "Current Location"
        }
        guard let locality = placemark.locality else {
            
            guard let city = placemark.subAdministrativeArea else {
                return "Current Location"
            }
            return city
        }
        return locality
    }
    
    private func weatherRequest(from response: MKLocalSearch.Response?, title: String) -> WeatherRequestType? {
        guard let item = response?.mapItems.first else {
            return nil
        }
        let itemCoordinate = item.placemark.coordinate
        return WeatherRequest(cityName: title,
                       latitude: itemCoordinate.latitude,
                       longitude: itemCoordinate.longitude)
    }
    
}

