//
//  MainViewController.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 17.03.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        networkService.getWeather(for: "Paris") { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("Ошибка при получении данных о погоде: \(error)")
            }
        }
    }


}

