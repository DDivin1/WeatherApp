//
//  CitiesStorageMock.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 7.03.26.
//

@testable import WeatherApp
import XCTest

// MARK: - CitiesStorageMock
final class CitiesStorageMock: ICitiesStorage {
    
    // MARK: - Mock Data
    private var mockSavedCities: [CityInfo] = []
    private var mockCurrentCity: CityInfo?
    
    // MARK: - Call Tracking
    var getSavedCityCalled = false
    var saveCitiesCalled = false
    var removeCityCalled = false
    var getCurrentCityCalled = false
    var saveCurrentCityCalled = false
    
    // MARK: - Parameter Tracking
    var lastSavedCity: CityInfo?
    var lastRemovedCity: CityInfo?
    var lastSavedCurrentCity: CityInfo?
    
    // MARK: - ICitiesStorage Methods
    func getSavedCity() -> [CityInfo] {
        getSavedCityCalled = true
        return mockSavedCities
    }
    
    func getCurrentCity() -> CityInfo? {
        getCurrentCityCalled = true
        return mockCurrentCity
    }
    
    func removeCity(_ city: CityInfo) {
        removeCityCalled = true
        lastRemovedCity = city
        mockSavedCities.removeAll {$0.name == city.name && $0.country == city.country}
    }
    
    func saveCities(_ city: CityInfo) {
        saveCitiesCalled = true
        lastSavedCity = city
        if !mockSavedCities.contains(where: {$0.name == city.name && $0.country == city.country}) {
            mockSavedCities.append(city)
        }
    }
    
    func saveCurrentCity(_ city: CityInfo) {
        saveCurrentCityCalled = true
        lastSavedCurrentCity = city
        mockCurrentCity = city
    }
    
    // MARK: - Helper Methods
    func setSavedCities(_ cities: [CityInfo]) {
        mockSavedCities = cities
    }
    
    func setCurrentCity(_ city: CityInfo?) {
        mockCurrentCity = city
    }
    
    func clearFlags() {
        getSavedCityCalled = false
        saveCitiesCalled = false
        removeCityCalled = false
        getCurrentCityCalled = false
        saveCurrentCityCalled = false
        lastSavedCity = nil
        lastRemovedCity = nil
        lastSavedCurrentCity = nil
    }
}
