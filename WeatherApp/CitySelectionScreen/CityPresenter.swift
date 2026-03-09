//
//  CityPresenter.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 27.02.26.
//

import Foundation

// MARK: - Protocols
protocol ICityPresenter {
    func viewDidLoad()
    func loadSavedCities()
    func searchCity(query: String)
    func didSelectCity(_ city: CityInfo)
    func deleteCity(_ city: CityInfo)
}

// MARK: - CityPresenter
final class CityPresenter: ICityPresenter {
    
    // MARK: - Properties
    var view: ICityView?
    private let networkService: INetworkService
    private let citiesStorage: ICitiesStorage
    private var mainPresenter: IMVPPresenter?
    
    // MARK: - Initialization
    init(networkService: INetworkService,
         citiesStorage: ICitiesStorage,
         mainPresenter: IMVPPresenter?) {
        self.networkService = networkService
        self.citiesStorage = citiesStorage
        self.mainPresenter = mainPresenter
    }
    
    // MARK: - ICityPresenter Methods
    func viewDidLoad() {
        loadSavedCities()
    }
    
    func loadSavedCities() {
        let cities = citiesStorage.getSavedCity()
        print("Загруженно городов: \(cities.count)")
        view?.displaySavedCities(cities)
    }
    
    func searchCity(query: String) {
        print("Поиск города: \(query)")
        
        networkService.searchCities(query: query) { [weak self] cities in
            guard let cities = cities else {
                self?.view?.displaySearchResults(cities ?? [])
                return
            }
            print("Найдено городов: \(cities.count)")
            self?.view?.displaySearchResults(cities)
        }
    }
    
    func didSelectCity(_ city: CityInfo) {
        citiesStorage.saveCurrentCity(city)
        citiesStorage.saveCities(city)
        
        let saved = citiesStorage.getSavedCity()
        print("После сохранени города: \(saved.count)")
        mainPresenter?.didSelectCity(city)
    }
    
    func deleteCity(_ city: CityInfo) {
        citiesStorage.removeCity(city)
        loadSavedCities()
    }
}
