//
//  LocationService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 19.03.2024.
//

import CoreLocation

final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    //MARK: Inizialization
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка: \(error)")
    }
}
