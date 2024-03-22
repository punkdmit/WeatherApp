//
//  WeatherResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let city: String
    let temperature: Temperature
    let weatherDescription: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case temperature = "main"
        case weatherDescription = "weather"
    }
    
    static func returnUppercased(weather: String?) -> String {
        guard let weather = weather else {
            return ""
        }
        let result = weather.prefix(1).uppercased() + weather.dropFirst()
        return result
    }
}

struct Temperature: Codable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "temp"
    }
}

struct WeatherCondition: Codable {
    let weather: String
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weather = "main"
        case weatherDescription = "description"
    }
}
