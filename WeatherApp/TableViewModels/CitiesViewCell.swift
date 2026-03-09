//
//  CitiesViewCell.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 27.02.26.
//

import SnapKit
import UIKit

// MARK: - CitiesViewCell
final class CitiesViewCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String { "\(Self.self)" }
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = CitiesViewCellConstants.cityLabelTextColor
        label.font = CitiesViewCellConstants.cityLabelFont
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(with city: String) {
        cityLabel.text = city
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
    }
}
