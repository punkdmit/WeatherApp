//
//  SearchTableViewCell.swift
//  WeatherApp-Aston
//
//  Created by Dmitry Apenko on 22.03.2024.
//

import Foundation
import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    //MARK: Static properties
    
    static var identifier: String { "\(Self.self)" }
    
    //MARK: Private properties

    private lazy var rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h4
        label.textColor = .black
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = .black
        return label
    }()
    
    private lazy var rightView = UIView()
    
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

extension SearchTableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        countryLabel.text = nil
    }
    
    func configure(with model: CityTableViewCellModel) {
        cityLabel.text = model.name + ", "
        countryLabel.text = model.country
        if !model.state.isEmpty {
            stateLabel.text = ", " + model.state
        } else {
            stateLabel.text = nil
        }
    }
}

//MARK: Private methods

private extension SearchTableViewCell {
    
    func setupUI() {
        backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(cityLabel)
        rootStackView.addArrangedSubview(countryLabel)
        rootStackView.addArrangedSubview(stateLabel)
        rootStackView.addArrangedSubview(rightView)
        
        cityLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        rootStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(AppConstants.normalSpacing)
        }
    }
    
}
