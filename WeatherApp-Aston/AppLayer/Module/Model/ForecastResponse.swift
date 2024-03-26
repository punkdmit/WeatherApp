//
//  ForecastResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 20.03.2024.
//

import Foundation

struct ForecastResponse: Codable {
    let city: City
    let forecasts: [DailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case city
        case forecasts = "list"
    }
}

struct City: Codable {
    let name: String
}

struct DailyForecast: Codable {
    let date: String
    let temperature: Temperature
    let weatherDescription: [ForecastCondition]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case temperature = "main"
        case weatherDescription = "weather"
    }
    
    struct Temperature: Codable {
        let max: Double
        let min: Double
        
        enum CodingKeys: String, CodingKey {
            case max = "temp_max"
            case min = "temp_min"
        }
    }
}

struct ForecastCondition: Codable {
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}
