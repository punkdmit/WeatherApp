//
//  WeatherView.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 18.03.2024.
//

import SnapKit

final class WeatherView: UIView {
    
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
    
    //MARK: Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        return tableView
    }()
    
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
}

//MARK: Private methods

private extension WeatherView {
    
    func setupUI() {
        backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(rootStack)
        rootStack.addArrangedSubview(cityLabel)
        rootStack.addArrangedSubview(temperatureLabel)
        rootStack.addArrangedSubview(descriptionLabel)
        
        addSubview(tableView)
        
        rootStack.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(rootStack.snp.bottom).offset(AppConstants.normalSpacing)
//            $0.width.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

