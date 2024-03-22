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
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private let viewModel = WeatherViewModel()
    
    private let locationService = LocationService()
    
    //MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        setupViewModel()
        fetchWeather()
        locationService.startUpdatingLocation()
        setupViewModel()
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
    
    func setupViewModel() {
        viewModel.didUpdateWeather = { [weak self] in
            if let weather = self?.viewModel.weather {
                self?.weatherView.update(with: weather)
            }
        }
        
        viewModel.didUpdateForecast = { [weak self] in
            self?.weatherView.reloadData()
        }
    }
    
    func fetchWeather() {
        viewModel.fetchWeather(for: locationService.currentLocation ?? CLLocationCoordinate2D())
        viewModel.fetchForecast(for: locationService.currentLocation ?? CLLocationCoordinate2D())
    }

}

// MARK: UITableViewDelegate, UITableViewDataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.forecast?.forecasts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        if let forecast = viewModel.forecast?.forecasts[indexPath.row] {
            let cellModel = ForecastTableViewCellModel(
                description: forecast.weatherDescription.first?.weatherDescription.capitalized,
                minTemp: forecast.temperature.min,
                maxTemp: forecast.temperature.max,
                date: forecast.date
            )
            cell.configure(with: cellModel)
        }
        return cell
    }
}

