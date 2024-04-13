//
//  LocationService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 19.03.2024.
//

import CoreLocation

protocol ILocationService {
    var currentLocation: Bindable<CLLocationCoordinate2D?> { get }
    var locationGroup: DispatchGroup { get }
    func requestLocation()
}

final class LocationService: NSObject, ILocationService {
    
    let locationManager = CLLocationManager()
    var currentLocation = Bindable<CLLocationCoordinate2D?>(nil)
    let locationGroup = DispatchGroup()
    
    //MARK: Inizialization
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

//MARK: Internal properties

extension LocationService {
    
    func requestLocation() {
        locationGroup.enter()
        locationManager.requestLocation()
    }
}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation.value = locations.first?.coordinate
        locationGroup.leave()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error)")
        locationGroup.leave()
    }
}
