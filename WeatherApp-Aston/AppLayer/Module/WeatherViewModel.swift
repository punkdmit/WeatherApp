//
//  WeatherViewModel.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
    
    var weather: Weather? {
        didSet {
            self.didUpdateWeather?()
        }
    }
    
    var didUpdateWeather: (() -> Void)?
    
    let networkService = NetworkService()
    
    func fetchWeather(for city: String) {
        networkService.getWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather = weather
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWeather(for location: CLLocationCoordinate2D) {
        networkService.getWeather(for: location) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather = weather
            case .failure(let error):
                print(error)
            }
        }
    }
}
