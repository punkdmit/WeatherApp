//
//  Bindable.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 22.03.2024.
//

import Foundation

class Bindable<T> {
    typealias Listener = (T) -> Void
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: Listener?
    
    init(_ v: T) {
        value = v
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
