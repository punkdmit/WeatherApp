//
//  Weather.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import Foundation

import Foundation

struct Weather: Codable {
    let city: String
    let main: Main
    let weather: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case main
        case weather
    }
    
    struct Main: Codable {
        let temp: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
        }
    }
    
    struct WeatherCondition: Codable {
        let main: String
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case main
            case description
        }
    }
}

