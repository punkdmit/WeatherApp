//
//  ForecastTableViewCellModel.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 20.03.2024.
//

import Foundation

struct ForecastTableViewCellModel {
    let description: String?
    let minTemp: Double?
    let maxTemp: Double?
    let date: String?
    
    func getDate(date: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.string(for: date)
    }
}
