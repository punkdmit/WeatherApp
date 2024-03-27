//
//  FilteredForecastResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 26.03.2024.
//

import Foundation

struct ConvertedForecastResponse: Codable {
    let city: String
    let forecasts: [CustomDailyForecast]
}

struct CustomDailyForecast: Codable {
    let date: String
    let minTemperature: Int?
    let maxTemperature: Int?
    let description: String?
}
