//
//  WeatherViewModel.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
        
    var weather = Bindable<WeatherResponse?>(nil)
    var forecast = Bindable<ForecastResponse?>(nil)
    var cities = Bindable<[CitiesResponse]?>(nil)
    
    var isSearching = false
    var searchText: String?
    
    let networkService = NetworkService()
    
    func fetchWeather(for city: String) {
        networkService.getWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather.value = weather
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchWeather(for location: CLLocationCoordinate2D) {
        networkService.getWeather(for: location) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather.value = weather
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchForecast(for city: String) {
        networkService.getForecast(for: city) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecast.value = forecast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchForecast(for location: CLLocationCoordinate2D) {
        networkService.getForecast(for: location) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecast.value = forecast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCity(for city: String) {
        networkService.getCities(for: city) { [weak self] result in
            switch result {
            case .success(let city):
                self?.cities.value = city
            case .failure(let error):
                print(error)
            }
        }
    }
}
