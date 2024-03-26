//
//  FilteredForecastResponse.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 26.03.2024.
//

import Foundation

struct FilteredForecastResponse: Codable {
    let city: String
    let dailyForecasts: [CustomDailyForecast]
}

struct CustomDailyForecast: Codable {
    let date: Date
    let minTemperature: Double?
    let maxTemperature: Double?
    let descriptions: [String?]
}
