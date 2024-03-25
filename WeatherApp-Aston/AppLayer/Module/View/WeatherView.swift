//
//  WeatherView.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import SnapKit

final class WeatherView: UIView {
    
    // MARK: Constants
    
    private enum Constants {
        static let currentWeatherButtonText = "Current location"
    }
    
    weak var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }
    
    weak var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }
    
    var currentWeatherButtonAction: Bindable<Void> = Bindable(())
    
    //MARK: Private properties
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var tableHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppConstants.normalSpacing
        return stack
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = SemiboldFont.h2
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = SemiboldFont.h1
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = RegularFont.p1
        return label
    }()
    
    private lazy var requestCurrentWeatherButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.currentWeatherButtonText, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(requestCurrentWeatherButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Inizialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Internal methods

extension WeatherView {
    
    func update(with weather: WeatherResponse) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = "\(weather.temperature.value)°C"
            self.descriptionLabel.text = WeatherResponse.returnUppercased(
                weather: weather.weatherDescription.first?.weatherDescription
            )
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupWhenSearching() {
        tableView.tableHeaderView = nil
    }
    
    func setupWhenFinishSearching() {
        tableView.tableHeaderView = tableHeaderStack
        tableHeaderStack.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(tableView.snp.top)
        }
    }
    
    func showCurrentWeatherButton() {
        requestCurrentWeatherButton.isHidden = false
    }
    
    func hideCurrentWeatherButton() {
        requestCurrentWeatherButton.isHidden = true
    }
}

//MARK: Obj-c methods

extension WeatherView {
    
    @objc private func requestCurrentWeatherButtonTapped() {
        currentWeatherButtonAction.value = ()
    }
}

//MARK: Private methods

private extension WeatherView {
    
    func setupUI() {
        backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(tableView)
        tableView.tableHeaderView = tableHeaderStack
        
        tableHeaderStack.addArrangedSubview(cityLabel)
        tableHeaderStack.addArrangedSubview(temperatureLabel)
        tableHeaderStack.addArrangedSubview(descriptionLabel)
        tableHeaderStack.addArrangedSubview(requestCurrentWeatherButton)
        
        tableHeaderStack.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(tableView.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

