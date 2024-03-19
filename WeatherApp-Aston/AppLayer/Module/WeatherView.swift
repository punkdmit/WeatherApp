//
//  WeatherView.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import SnapKit

final class WeatherView: UIView {
    
    //MARK: Private properties
    
    private lazy var tableView = UITableView()
    
    private lazy var rootStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppConstants.normalSpacing
        stack.layer.borderColor = UIColor.red.cgColor
        stack.layer.borderWidth = 2
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
    
    func update(with weather: Weather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = "\(weather.temperature.value)°C"
            self.descriptionLabel.text = Weather.returnUppercased(
                weather: weather.weather.first?.weatherDescription
            )
        }
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
        tableView.addSubview(rootStack)
        rootStack.addArrangedSubview(cityLabel)
        rootStack.addArrangedSubview(temperatureLabel)
        rootStack.addArrangedSubview(descriptionLabel)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rootStack.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
        }

//        cityLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//        
//        temperatureLabel.snp.makeConstraints {
//            $0.top.equalTo(cityLabel.snp.bottom).offset(10)
//            $0.center.equalToSuperview()
//        }
//        
//        conditionLabel.snp.makeConstraints {
//            $0.top.equalTo(temperatureLabel.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//        }
    }
}

