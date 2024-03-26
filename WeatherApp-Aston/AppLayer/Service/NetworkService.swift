//
//  NetworkService.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 17.03.2024.
//

import Foundation
import CoreLocation

private enum Endpoints: String {
    case weather = "/weather"
    case forecast = "/forecast"
    case direct = "/direct"
}

private enum HttpType: String {
    case get = "GET"
}

private extension NSError {
    static let networkError = NSError(domain: "Network Error", code: 0)
    static let parseError = NSError(domain: "Parse Error", code: 2)
}

private extension String {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let baseGeoURL = "http://api.openweathermap.org/geo/1.0"
    static let apiKey = "2d156d61ee4d8e9cd8495b63ff4e8c76"
    static let units = "metric"
    static let citiesLimit = "3"
}

final class NetworkService {
    
    func getWeather(for location: CLLocationCoordinate2D, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let request = createLocationWeatherRequest(for: location, Endpoints.weather) else {
            completion(.failure(NSError.networkError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                if let weather = self.parseWeatherData(data: data) {
                    completion(.success(weather))
                } else {
                    completion(.failure(NSError.parseError))
                }
            } else {
                completion(.failure(NSError.networkError))
            }
        }
        task.resume()
    }
    
    func getForecast(for location: CLLocationCoordinate2D, completion: @escaping (Result</*ForecastResponse*/FilteredForecastResponse, Error>) -> Void) {
        guard let request = createLocationWeatherRequest(
            for: location,
            Endpoints.forecast
        ) else {
            completion(.failure(NSError.networkError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                if let forecast = self.parseForecastData(data: data) {
                    
//                    let customForecast = self.transformForecastData(forecast)
//                    completion(.success(customForecast))
                    
                    completion(.success(forecast))
                } else {
                    completion(.failure(NSError.parseError))
                }
            } else {
                completion(.failure(NSError.networkError))
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
//    func getWeather(for cityName: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
//        guard let request = createLocationWeatherRequest(for: location, Endpoints.weather) else {
//            completion(.failure(NSError.networkError))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data {
//                if let weather = self.parseWeatherData(data: data) {
//                    completion(.success(weather))
//                } else {
//                    completion(.failure(NSError.parseError))
//                }
//            } else {
//                completion(.failure(NSError.networkError))
//            }
//        }
//        task.resume()
//    }
//    
//    func getForecast(for cityName: String, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
//        guard let request = createLocationWeatherRequest(
//            for: location,
//            Endpoints.forecast
//        ) else {
//            completion(.failure(NSError.networkError))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response , error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data {
//                if let forecast = self.parseForecastData(data: data) {
//                    completion(.success(forecast))
//                } else {
//                    completion(.failure(NSError.parseError))
//                }
//            } else {
//                completion(.failure(NSError.networkError))
//            }
//        }
//        task.resume()
//    }
//    
    
    
    
    
    
    
    
    
    func getCities(for cityName: String, completion: @escaping (Result<[CityResponse], Error>) -> Void) {
        guard let request = createCityListRequest(for: cityName, .direct) else {
            completion(.failure(NSError.networkError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                if let cities = self.parseCitiesData(data: data) {
                    completion(.success(cities))
                } else {
                    completion(.failure(NSError.parseError))
                }
            } else {
                completion(.failure(NSError.networkError))
            }
        }
        task.resume()
    }
    
    private func createLocationWeatherRequest(for location: CLLocationCoordinate2D, _ endpoint: Endpoints) -> URLRequest? {
        guard let url = URL(string: .baseURL + endpoint.rawValue) else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: .apiKey),
            URLQueryItem(name: "units", value: .units)
        ]
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = HttpType.get.rawValue
        return request
    }
    
    private func createCityListRequest(for city: String, _ endpoint: Endpoints) -> URLRequest? {
        guard let url = URL(string: .baseGeoURL + endpoint.rawValue) else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "limit", value: .citiesLimit),
            URLQueryItem(name: "appid", value: .apiKey),
        ]
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = HttpType.get.rawValue
        return request
    }
    
    private func parseWeatherData(data: Data) -> WeatherResponse? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherResponse.self, from: data)
            return weatherData
        } catch {
            print("Ошибка декордирования погоды: \(error)")
            return nil
        }
    }
    
    private func parseForecastData(data: Data) -> /*ForecastResponse?*/FilteredForecastResponse?{
        let decoder = JSONDecoder()
        do {
            let forecastData = try decoder.decode(ForecastResponse.self /*FilteredForecastResponse.self*/, from: data)
            let filtered = transformForecastData(forecastData)
            return filtered
//            return forecastData
        } catch {
            print("Ошибка декордирования прогноза: \(error)")
            return nil
        }
    }
    
    private func parseCitiesData(data: Data) -> [CityResponse]? {
        let decoder = JSONDecoder()
        do {
            let citiesData = try decoder.decode([CityResponse].self, from: data)
            return citiesData
        } catch {
            print("Ошибка декордирования городов: \(error)")
            return nil
        }
    }
    
    private func transformForecastData(_ forecast: ForecastResponse) -> FilteredForecastResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let groupedForecasts = Dictionary(grouping: forecast.forecasts) { forecast -> Date in
            guard let date = dateFormatter.date(from: forecast.date) else {
                fatalError("Не удалось преобразовать дату")
            }
            return Calendar.current.startOfDay(for: date)
        }
        
        let dailyForecasts = groupedForecasts.map { date, forecasts in
            let minTemperature = forecasts.min(by: { $0.temperature.min < $1.temperature.min })?.temperature.min
            let maxTemperature = forecasts.max(by: { $0.temperature.max < $1.temperature.max })?.temperature.max
            let descriptions = forecasts.flatMap { $0.weatherDescription.map { $0.weatherDescription } }
            return CustomDailyForecast(date: date, minTemperature: minTemperature, maxTemperature: maxTemperature, descriptions: descriptions)
        }
        
        return FilteredForecastResponse(city: forecast.city.name, dailyForecasts: dailyForecasts)
    }

    
}
