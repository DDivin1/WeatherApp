//
//  CitiesStorage.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import Foundation

// MARK: - Protocols
protocol ICitiesStorage {
    func getSavedCity() -> [CityInfo]
    func saveCities(_ city: CityInfo)
    func removeCity(_ city: CityInfo)
    func getCurrentCity() -> CityInfo?
    func saveCurrentCity(_ city: CityInfo)
}

// MARK: - CitiesStorage
final class CitiesStorage: ICitiesStorage {
    
    // MARK: - Constants
    private let userDefaults = UserDefaults.standard
    private let citiesKey = "cities"
    private let currentCityKey = "currentCity"
    
    // MARK: - Public Methods
    func getSavedCity() -> [CityInfo] {
        guard let data = userDefaults.data(forKey: citiesKey),
              let cities = try? JSONDecoder().decode([CityInfo].self, from: data) else {
            return []
        }
        return cities
    }
    
    func saveCities(_ city: CityInfo) {
        var cities = getSavedCity()
        if !cities.contains(where: { $0.name == city.name && $0.country == city.country }) {
            cities.append(city)
            if let data = try? JSONEncoder().encode(cities) {
                userDefaults.set(data, forKey: citiesKey)
            }
        }
    }
    
    func removeCity(_ city: CityInfo) {
        var cities = getSavedCity()
        cities.removeAll { $0.name == city.name && $0.country == city.country }
        if let data = try? JSONEncoder().encode(cities) {
            userDefaults.set(data, forKey: citiesKey)
        }
    }
    
    func getCurrentCity() -> CityInfo? {
        guard let data = userDefaults.data(forKey: currentCityKey),
              let city = try? JSONDecoder().decode(CityInfo.self, from: data) else {
            return nil
        }
        return city
    }
    
    func saveCurrentCity(_ city: CityInfo) {
        if let data = try? JSONEncoder().encode(city) {
            userDefaults.set(data, forKey: currentCityKey)
        }
    }
}
