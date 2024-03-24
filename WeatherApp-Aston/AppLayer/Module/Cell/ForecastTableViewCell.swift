//
//  ForecastTableViewCell.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 20.03.2024.
//

import Foundation
import UIKit

final class ForecastTableViewCell: UITableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let temperatureMetric = "°C"
        static let separator = " ⎯ "
    }
    

    
    //MARK: Static properties
        
    static var identifier: String { "\(Self.self)" }
    
    //MARK: Private properties

    private lazy var rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = AppConstants.compactSpacing
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()

    private lazy var secondStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()

    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()
    
    //MARK: Inizialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Internal methods

extension ForecastTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        minTempLabel.text = nil
        maxTempLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with model: ForecastTableViewCellModel) {
        dateLabel.text = model.date
        minTempLabel.text = "\(model.minTemp ?? Double())" + Constants.temperatureMetric + Constants.separator
        maxTempLabel.text = "\(model.maxTemp ?? Double())" + Constants.temperatureMetric
        descriptionLabel.text = model.description
    }
}

//MARK: Private methods

private extension ForecastTableViewCell {
    
    func setupUI() {
        backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(firstStackView)
        rootStackView.addArrangedSubview(secondStackView)
        
        firstStackView.addArrangedSubview(dateLabel)
        firstStackView.addArrangedSubview(minTempLabel)
        firstStackView.addArrangedSubview(maxTempLabel)
        
        secondStackView.addArrangedSubview(descriptionLabel)
        
        rootStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(AppConstants.normalSpacing)
        }
    }
    
}
