//
//  LocationService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 19.03.2024.
//

import CoreLocation

final class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    let locationSemaphore = DispatchSemaphore(value: 0)

    let locationGroup = DispatchGroup()
    
    //MARK: Inizialization
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocation()
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
        currentLocation = locations.first?.coordinate
        locationGroup.leave()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error)")
        locationGroup.leave()
    }
}
