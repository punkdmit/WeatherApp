//
//  LocationService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 19.03.2024.
//

import CoreLocation

final class LocationService: NSObject {
    
    /*private*/ let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
//    let locationGroup = DispatchGroup()
    let locationSemaphore = DispatchSemaphore(value: 0)


//    static let shared = LocationService()
    
    //MARK: Inizialization
    
    /*private*/ override init() {
//        locationGroup.enter()
        locationManager.requestWhenInUseAuthorization()
        super.init()
//        locationSemaphore.signal()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
//            locationGroup.leave()
        locationSemaphore.signal()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error)")
//            locationGroup.leave()
        locationSemaphore.signal()
    }
}
