//
//  WeatherViewModel.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
    
    // MARK: Constants
    
    private enum Constants {
        static let inputeDateFormat = "yyyy-MM-dd HH:mm:ss"
        static let outputDateFormat = "MMM d"
        static let localeIdentifire = "EN_en"
    }
    
    var weather = Bindable<WeatherResponse?>(nil)
    var forecast = Bindable<ConvertedForecastResponse?>(nil)
    var cities = Bindable<[CityResponse]?>(nil)
    
    var isSearching = Bindable<Bool>(false)
    var searchText = Bindable<String?>("")
    
    private let networkService = NetworkService()
    private let locationService = LocationService()
    
    
    
    func fetchWeather() {
        DispatchQueue.global().async {
            self.locationService.locationGroup.wait()
            guard let location = self.locationService.currentLocation else {
                return
            }
            self.networkService.getWeather(for: location) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weather):
                    self.weather.value = weather
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    func fetchWeather(for location: CLLocationCoordinate2D) {
        self.networkService.getWeather(for: location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                self.weather.value = weather
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    func fetchForecast() {
        DispatchQueue.global().async {
            self.locationService.locationGroup.wait()
            guard let location = self.locationService.currentLocation else {
                return
            }
            self.networkService.getForecast(for: location) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let forecast):
                    self.forecast.value = self.convertForecastData(forecast)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchForecast(for location: CLLocationCoordinate2D) {
        self.networkService.getForecast(for: location) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                self.forecast.value = self.convertForecastData(forecast)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func fetchCity(for city: String) {
        networkService.getCities(for: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let city):
                self.cities.value = city
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: Private methods

private extension WeatherViewModel {
    
    func convertForecastData(_ forecast: ForecastResponse) -> ConvertedForecastResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.inputeDateFormat
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifire)
        
        let groupedForecasts = Dictionary(grouping: forecast.forecasts) { forecast -> Date in
            guard let date = dateFormatter.date(from: forecast.date) else {
                return Date()
            }
            return Calendar.current.startOfDay(for: date)
        }
        
        dateFormatter.dateFormat = Constants.outputDateFormat
        
        let dailyForecasts = groupedForecasts.map { date, forecasts in
            let date = dateFormatter.string(from: date)
            let minTemperature = forecasts.min(by: { $0.temperature.min < $1.temperature.min })?.temperature.min
            let maxTemperature = forecasts.max(by: { $0.temperature.max < $1.temperature.max })?.temperature.max
            let descriptions = forecasts.flatMap { $0.weatherDescription.map { $0.weatherDescription } }
            return CustomDailyForecast(
                date: date,
                minTemperature: Int(round(minTemperature ?? Double())),
                maxTemperature: Int(round(maxTemperature ?? Double())),
                description: descriptions.first
            )
        }
        
        var sortedForecasts = dailyForecasts.sorted { $0.date < $1.date }
        sortedForecasts.removeFirst()
        
        let filteredForecastResponse = ConvertedForecastResponse(city: forecast.city.name, forecasts: sortedForecasts)
        
        return filteredForecastResponse
    }
}

