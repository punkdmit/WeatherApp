//
//  CitiesResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 22.03.2024.
//

import Foundation

struct CityResponse: Codable {
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}
