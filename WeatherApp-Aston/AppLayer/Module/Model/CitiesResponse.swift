//
//  CitiesResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 22.03.2024.
//

import Foundation

struct CitiesResponse: Codable {
    let name: String
    let country: String
    let state: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case state
        case lat
        case lon
    }
}

//struct CitiesContainer: Codable {
//    let data: [CitiesResponse]
//}
