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
        static let navigationItemTitle = "Current place"
        static let searchBarTitle = "Input city"
        static let inputDateFormat = "yyyy-MM-dd HH:mm:ss"
        static let outputDateFormat = "MMM d"
    }
    
    //MARK: Private properties
    
    private var searchController = UISearchController(searchResultsController: nil)
    private let viewModel = WeatherViewModel()
    private let dateFormatter = DateFormatter()
    
    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    //MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        bindViewModel()
    }
}

//MARK: UISearchResultsUpdating

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.isSearching.value = searchController.searchBar.text.isNotEmpty
        
        if searchController.searchBar.text != viewModel.searchText.value, viewModel.isSearching.value {
            viewModel.searchText.value = searchController.searchBar.text
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.isSearching.value != false {
        case false:
            viewModel.forecast.value?.forecasts.count ?? 0
        case true:
            viewModel.cities.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.isSearching.value != false {
        case true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            
            if let city = viewModel.cities.value?[indexPath.row] {
                let cellModel = CityTableViewCellModel(
                    name: city.name,
                    country: city.country,
                    state: city.state ?? "",
                    lat: city.lat,
                    lon: city.lon
                )
                cell.configure(with: cellModel)
            }
            return cell
            
        case false:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {
                return UITableViewCell()
            }
            
            if let forecast = viewModel.forecast.value?.forecasts[indexPath.row] {
                let cellModel = ForecastTableViewCellModel(
                    description: forecast.weatherDescription.first?.weatherDescription.capitalized,
                    minTemp: forecast.temperature.min,
                    maxTemp: forecast.temperature.max,
                    date: formatDate(from: forecast.date)
                )
                cell.configure(with: cellModel)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let city = viewModel.cities.value?[indexPath.row] else { return }
        
        showCurrentWeatherButton()
        hideNavigationTitle()
        
        setupViewModel(for: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon))
        searchController.isActive = false
    }
}

//MARK: Private methods

private extension WeatherViewController {
    
    func setupUI() {
        showNavigationTitle()
        hideCurrentWeatherButton()
        setupSearchController()
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(weatherView)
        
        weatherView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupViewModel() {
        LocationService.shared.currentLocation.bind { [weak self] location in
            
            guard let location = location, let self = self else {
                return
            }
            
            viewModel.fetchWeather(for: location)
            viewModel.fetchForecast(for: location)
            
//            showNavigationTitle()
//            hideCurrentWeatherButton()
        }
    }
    
    func setupViewModel(for coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {
            return
        }
        
        viewModel.fetchWeather(for: coordinates)
        viewModel.fetchForecast(for: coordinates)
        
//        showCurrentWeatherButton()
//        hideNavigationTitle()
    }
    
    func bindViewModel() {
        viewModel.weather.bind { [weak self] _ in
            guard let self = self else { return }
            
            if let weather = viewModel.weather.value {
                weatherView.update(with: weather)
            }
        }
        
        viewModel.forecast.bind { [weak self] _ in
            guard let self = self else { return }
            weatherView.reloadData()
        }
        
        weatherView.currentWeatherButtonAction.bind { [weak self] _ in
            guard let self = self else { return }
            
            showNavigationTitle()
            hideCurrentWeatherButton()
            LocationService.shared.requestLocation()
        }
        
        viewModel.searchText.bind { [weak self] text in
            guard let self = self else { return }
            
            if let text = text, !text.isEmpty {
                viewModel.fetchCity(for: text)
            }
        }
        
        viewModel.cities.bind { [weak self] _ in
            guard let self = self else { return }
            weatherView.reloadData()
        }
        
        viewModel.isSearching.bind { [weak self] _ in
            guard let self = self else { return }
            
            viewModel.isSearching.value == true
            ? setupWhenSearching()
            : setupWhenFinishSearching()
        }
    }
    
    func setupWhenSearching() {
        weatherView.setupWhenSearching()
    }
    
    func setupWhenFinishSearching() {
        viewModel.cities.value = nil
        viewModel.searchText.value = nil
        weatherView.setupWhenFinishSearching()
    }
    
    func showCurrentWeatherButton() {
        weatherView.showCurrentWeatherButton()
    }
    
    func hideCurrentWeatherButton() {
        weatherView.hideCurrentWeatherButton()
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarTitle
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func showNavigationTitle() {
        navigationItem.title = Constants.navigationItemTitle
    }
    
    func hideNavigationTitle() {
        navigationItem.title = nil
    }
    
    func formatDate(from string: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Constants.inputDateFormat
        
        if let date = inputFormatter.date(from: string) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_EN")
            outputFormatter.dateFormat = Constants.outputDateFormat
            
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

