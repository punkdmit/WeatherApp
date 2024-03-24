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
        static let searchBarTitle = "Input city"
    }
    
    //MARK: Private properties
    
    private var searchController = UISearchController(searchResultsController: nil)
    private let viewModel = WeatherViewModel()
    private let locationService = LocationService()
    
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    //MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchControoler()
        setupUI()
        locationService.startUpdatingLocation()
        fetchWeatherAndForcast(for: locationService.currentLocation ?? CLLocationCoordinate2D())
        setupViewModel()
    }
}

//MARK: Private methods

private extension WeatherViewController {
    
    func setupUI() {
        showNavigationTitle()
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(weatherView)
        
        weatherView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupViewModel() {
        viewModel.weather.bind { [weak self] _ in
            if let weather = self?.viewModel.weather.value {
                self?.weatherView.update(with: weather)
            }
        }
        
        viewModel.forecast.bind { [weak self] _ in
            self?.weatherView.reloadData()
        }
    }
    
    func fetchWeatherAndForcast(for location: CLLocationCoordinate2D) {
//        guard let location = location else { return }
        viewModel.fetchWeather(for: location)
        viewModel.fetchForecast(for: location)
    }

    func setupSearchControoler() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarTitle
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func showNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.navigationItemTitle
    }
    
    func hideNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = nil
    }
}

//MARK: UISearchResultsUpdating

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearching = searchController.searchBar.text.isNotEmpty
        
        if searchController.searchBar.text != viewModel.searchText {
            viewModel.searchText = searchController.searchBar.text
            viewModel.fetchCity(for: viewModel.searchText ?? "")
            viewModel.cities.bind { [weak self] _ in
                self?.weatherView.reloadData()
            }
        }
        
        if viewModel.isSearching {
            weatherView.setupWhenSearching()
        } else {
            weatherView.setupWhenNotSearching()
        }

    }
}


// MARK: UITableViewDelegate, UITableViewDataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.isSearching != false {
        case false:
            viewModel.forecast.value?.forecasts.count ?? 0
        case true:
            viewModel.cities.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.isSearching != false {
        case false:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {
                return UITableViewCell()
            }
            
            if let forecast = viewModel.forecast.value?.forecasts[indexPath.row] {
                let cellModel = ForecastTableViewCellModel(
                    description: forecast.weatherDescription.first?.weatherDescription.capitalized,
                    minTemp: forecast.temperature.min,
                    maxTemp: forecast.temperature.max,
                    date: forecast.date
                )
                cell.configure(with: cellModel)
            }
            return cell
            
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            
            if let city = viewModel.cities.value?[indexPath.row] {
                let cellModel = CityTableViewCellModel(
                    name: city.name,
                    country: city.country,
                    state: city.state,
                    lat: city.lat,
                    lon: city.lon
                )
                cell.configure(with: cellModel)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let city = viewModel.cities.value?[indexPath.row] else { return }
        
        fetchWeatherAndForcast(for: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon))
        searchController.isActive = false
        hideNavigationTitle()
        setupViewModel()
    }
}

