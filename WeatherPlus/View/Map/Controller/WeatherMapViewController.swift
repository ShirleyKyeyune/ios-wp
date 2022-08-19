//
//  WeatherMapViewController.swift
//  WeatherPlus
//
//  Created by Shirley Kyeyune on 14/08/2022.
//

import UIKit
import MapKit

class WeatherMapViewController: UIViewController {
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    
    // MARK: - Private properties
    private lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        return map
    }()
    
    //private lazy var addCityView = AddWeatherLocationView(colorThemeComponent: colorThemeComponent)
    private let colorThemeComponent: ColorThemeProtocol
    
    private var currentLocation = Location(latitude: 0, longitude: 0)
    private var isCurrentLocationUpdated = false
    
    private var savedCityTitles: [WeatherMapLocation]
    
    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol, savedCityTitles: [WeatherMapLocation]) {
        self.colorThemeComponent = colorThemeComponent
        self.savedCityTitles = savedCityTitles
        super.init(nibName: nil, bundle: nil)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarTitleColor: UIColor = colorThemeComponent.colorTheme.cityDetails.isStatusBarDark ? .white : .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navBarTitleColor]
        
        navigationItem.title = "Weather Locations"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        mapView.delegate = self
        
        if(!savedCityTitles.isEmpty && isCurrentLocationUpdated) {
            loadWeatherLocationsOnMap(savedCityTitles)
            
            mapView.showsUserLocation = true
            
            //            // Set initial location to current
            //            let initialLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            //            mapView.centerToLocation(initialLocation)
            //
            //            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            //            mapView.setCameraZoomRange(zoomRange, animated: true)
            
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(viewRegion, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Private functions
    
    func setupMapToZoomIn() {

        if(!savedCityTitles.isEmpty && isCurrentLocationUpdated) {
            loadWeatherLocationsOnMap(savedCityTitles)
            
            mapView.showsUserLocation = true
            
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(viewRegion, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func loadWeatherLocationsOnMap(_ savedLocations: [WeatherMapLocation]) {
        for location in savedLocations {
            mapView.addAnnotation(location)
        }
    }
}

extension WeatherMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        currentLocation = Location(latitude: locationValue.latitude,
                                   longitude: locationValue.longitude)
        isCurrentLocationUpdated = true
        
        mapView.showsUserLocation = true
        setupMapToZoomIn()
    }
}

extension WeatherMapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard let annotation = annotation as? WeatherMapLocation else {
            return nil
        }
        let identifier = "weatherMapLocation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
