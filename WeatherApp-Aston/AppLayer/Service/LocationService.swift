//
//  LocationService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 19.03.2024.
//

import CoreLocation

final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    var currentLocation = Bindable<CLLocationCoordinate2D?>(nil)
    
    static let shared = LocationService()
    
    //MARK: Inizialization
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation.value = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error)")
    }
}
