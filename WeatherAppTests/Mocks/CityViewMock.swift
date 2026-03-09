//
//  CityViewMock.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 7.03.26.
//

@testable import WeatherApp
import Foundation

// MARK: - CityViewMock
class CityViewMock: ICityView {
    
    // MARK: - Call Tracking
    var displaySavedCitiesCalled = false
    var displaySearchResultsCalled = false
    
    // MARK: - Parameter Tracking
    var lastDisplayedSavedCities: [CityInfo]?
    var lastDisplayedSearchResults: [CityInfo]?
    
    // MARK: - ICityView Methods
    func displaySavedCities(_ cities: [CityInfo]) {
        displaySavedCitiesCalled = true
        lastDisplayedSavedCities = cities
    }
    
    func displaySearchResults(_ cities: [CityInfo]) {
        displaySearchResultsCalled = true
        lastDisplayedSearchResults = cities
    }
    
    // MARK: - Helper Methods
    func clearFlags() {
        displaySavedCitiesCalled = false
        displaySearchResultsCalled = false
        lastDisplayedSavedCities = nil
        lastDisplayedSearchResults = nil
    }
}
