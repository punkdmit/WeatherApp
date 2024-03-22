//
//  WeatherViewModel.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
    
    var weather: WeatherResponse? {
        didSet {
            self.didUpdateWeather?()
        }
    }
    
    var forecast: ForecastResponse? {
        didSet {
            self.didUpdateForecast?()
        }
    }
    
    var didUpdateWeather: (() -> Void)?
    var didUpdateForecast: (() -> Void)?
    
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
    
    func fetchForecast(for city: String) {
        networkService.getForecast(for: city) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecast = forecast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchForecast(for location: CLLocationCoordinate2D) {
        networkService.getForecast(for: location) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecast = forecast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //    func fetchForecast(for city: String) {
    //        networkService.getForecast(for: city) { [weak self] result in
    //            switch result {
    //            case .success(let forecast):
    //                DispatchQueue.main.async {
    //                    self?.forecast = forecast
    ////                    self?.didUpdateForecast?()
    //                }
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    //    }
}
