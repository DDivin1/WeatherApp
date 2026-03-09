//
//  MVPPresenter.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 24.02.26.
//

import Foundation
import UIKit

// MARK: - Protocols
protocol IMVPPresenter {
    func viewDidLoad()
    func burgerButtonPressed()
    func didReceiveWeather(_ weather: WeatherData)
    func didSelectCity(_ city: CityInfo)
}

// MARK: - Constants
private enum Constants {
    static let defaultCity = "Minsk"
}

// MARK: - MVPPresenter
final class MVPPresenter: IMVPPresenter {
    
    // MARK: - Properties
    var view: IMVPView?
    private let networkService: INetworkService
    private let citiesStorage: ICitiesStorage
    
    // MARK: - Initialization
    init(networkService: INetworkService = NetworkService(),
         citiesStorage: ICitiesStorage = CitiesStorage()) {
        self.networkService = networkService
        self.citiesStorage = citiesStorage
    }
    
    // MARK: - IMVPPresenter Methods
    func viewDidLoad() {
        if let currentCity = citiesStorage.getCurrentCity() {
            loadWeather(for: currentCity.name)
        } else {
            loadWeather(for: Constants.defaultCity)
        }
    }
    
    func burgerButtonPressed() {
        let cityVC = CityAssembly.assemble(mainPresenter: self)
        view?.presentCityScreen(cityVC)
    }
    
    func didReceiveWeather(_ weather: WeatherData) {
        print("Получена погода для: \(weather.cityName)")
        view?.updateView(with: weather)
    }
    
    func didSelectCity(_ city: CityInfo) {
        loadWeather(for: city.name)
    }
    
    // MARK: - Private Methods
    private func loadWeather(for cityName: String) {
        networkService.getWeatherForCity(cityName) { [weak self] weatherData in
            if let weatherData = weatherData {
                self?.didReceiveWeather(weatherData)
            }
        }
    }
}
