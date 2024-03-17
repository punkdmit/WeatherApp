//
//  String+extension.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 17.03.2024.
//

import Foundation

extension Optional where Wrapped == String {
    var isNotEmpty: Bool {
        return self != ""
    }
}
