//
//  MVPController.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 24.02.26.
//

import SnapKit
import UIKit

// MARK: - Protocols
protocol IMVPView {
    func updateView(with weather: WeatherData)
    func presentCityScreen(_ viewController: UIViewController)
}

// MARK: - MVPController
final class MVPController: UIViewController, IMVPView {
    
    // MARK: - UI Elements
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = MVPControllerConstants.Fonts.cityLabelFont
        label.textAlignment = .center
        label.text = MVPControllerConstants.Strings.defaultCity
        label.textColor = MVPControllerConstants.Colors.text
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = MVPControllerConstants.Fonts.temperatureLabelFont
        label.textAlignment = .center
        label.textColor = MVPControllerConstants.Colors.text
        label.text = MVPControllerConstants.Strings.defaultTemperature
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = MVPControllerConstants.Fonts.secondaryLabelFont
        label.textAlignment = .center
        label.textColor = MVPControllerConstants.Colors.text
        label.text = MVPControllerConstants.Strings.defaultFeelsLike
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = MVPControllerConstants.Fonts.secondaryLabelFont
        label.textAlignment = .center
        label.textColor = MVPControllerConstants.Colors.text
        label.text = MVPControllerConstants.Strings.defaultDescription
        return label
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.font = MVPControllerConstants.Fonts.secondaryLabelFont
        label.textAlignment = .center
        label.textColor = MVPControllerConstants.Colors.text
        label.text = MVPControllerConstants.Strings.defaultWind
        return label
    }()
    
    private let burgerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: MVPControllerConstants.Strings.burgerButtonImageName), for: .normal)
        button.tintColor = MVPControllerConstants.Colors.burgerButtonTint
        button.backgroundColor = MVPControllerConstants.Colors.burgerButtonBackground
        button.layer.cornerRadius = MVPControllerConstants.Layout.burgerButtonSize / 2
        return button
    }()
    
    // MARK: - Properties
    private let presenter: IMVPPresenter
    
    // MARK: - Initialization
    init(presenter: IMVPPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = MVPControllerConstants.Colors.background
        setupBurgerButton()
        setupLabels()
    }
    
    private func setupBurgerButton() {
        view.addSubview(burgerButton)
        burgerButton.snp.makeConstraints { make in
            make.height.width.equalTo(MVPControllerConstants.Layout.burgerButtonSize)
            make.left.equalToSuperview().offset(MVPControllerConstants.Layout.burgerButtonLeftOffset)
            make.top.equalToSuperview().offset(MVPControllerConstants.Layout.burgerButtonTopOffset)
        }
        
        let burgerButtonAction = UIAction { _ in
            self.burgerButtonPressed()
        }
        burgerButton.addAction(burgerButtonAction, for: .touchUpInside)
    }
    
    private func setupLabels() {
        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(MVPControllerConstants.Layout.cityLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(MVPControllerConstants.Layout.cityLabelHorizontalInset)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(MVPControllerConstants.Layout.temperatureLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(feelsLikeLabel)
        feelsLikeLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(MVPControllerConstants.Layout.feelsLikeLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(MVPControllerConstants.Layout.descriptionLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(MVPControllerConstants.Layout.windLabelTopOffset)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    private func burgerButtonPressed() {
        presenter.burgerButtonPressed()
    }
    
    // MARK: - IMVPView Methods
    func presentCityScreen(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func updateView(with weather: WeatherData) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeLabel.text = weather.feelsLikeString
            self.descriptionLabel.text = weather.description
            self.windLabel.text = weather.windString
        }
    }
}
