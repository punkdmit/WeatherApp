//
//  MainViewController.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 17.03.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let navigationItemTitle = "Текущее место"
    }
    
    //MARK: Private properties
    
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        return view
    }()

    private let viewModel = WeatherViewModel()
    
//    private let locationManager = CLLocationManager()
    private let locationService = LocationService()
    
    //MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchWeather()
//        setupLocationManager()
        locationService.startUpdatingLocation()
        updateView()
    }
}

//MARK: Private methods

private extension WeatherViewController {
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.navigationItemTitle
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(weatherView)
        
        weatherView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateView() {
        viewModel.didUpdateWeather = { [weak self] in
            if let weather = self?.viewModel.weather {
                self?.weatherView.update(with: weather)
            }
        }
    }
    
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
    
    func fetchWeather() {
//        viewModel.fetchWeather(for: "Moscow")
        viewModel.fetchWeather(for: locationService.currentLocation ?? CLLocationCoordinate2D())
    }

}

//MARK: CLLocationManagerDelegate


