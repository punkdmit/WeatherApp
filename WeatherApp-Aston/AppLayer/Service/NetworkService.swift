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
    static let apiKey = "2d156d61ee4d8e9cd8495b63ff4e8c76"
    static let units = "metric"
}

final class NetworkService {
    
    func getWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        guard let request = createCityWeatherRequest(for: city, Endpoints.weather) else {
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
    
    func getWeather(for location: CLLocationCoordinate2D, completion: @escaping (Result<Weather, Error>) -> Void) {
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
    
    private func createCityWeatherRequest(for city: String, _ endpoint: Endpoints) -> URLRequest? {
        guard let url = URL(string: .baseURL + endpoint.rawValue + "?units=metric") else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
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
    
    private func parseWeatherData(data: Data) -> Weather? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(Weather.self, from: data)
            return weatherData
        } catch {
            print("Error decoding weather data: \(error)")
            return nil
        }
    }
    
}
