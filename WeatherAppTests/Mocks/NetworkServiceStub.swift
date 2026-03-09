//
//  NetworkServiceStub.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 7.03.26.
//

@testable import WeatherApp

// MARK: - NetworkServiceStub
final class NetworkServiceStub: INetworkService {
    
    // MARK: - Test Control
    var searchCitiesResult: [CityInfo]?
    var getWeatherResult: WeatherData?
    var shoulReturnEror = false

    // MARK: - Call Tracking
    var getWeatherForCityCalled = false
    var searchCitiesCalled = false
    
    // MARK: - Parameter Tracking
    var lastSearchedCity: String?
    var lastSearchedQuery: String?
    
    // MARK: - INetworkService Methods
    func getWeatherForCity(_ cityName: String, completion: @escaping (WeatherApp.WeatherData?) -> Void) {
        getWeatherForCityCalled = true
        lastSearchedCity = cityName
        
        if shoulReturnEror {
            completion(nil)
        } else {
            completion(getWeatherResult)
        }
    }
    
    func searchCities(query: String, completion: @escaping ([WeatherApp.CityInfo]?) -> Void) {
        searchCitiesCalled = true
        lastSearchedQuery = query
        
        if shoulReturnEror {
            completion(nil)
        } else {
            completion(searchCitiesResult)
        }
    }
    
    // MARK: - Helper Methods
    func setSearchCitiesResult(_ result: [CityInfo]) {
        searchCitiesResult = result
    }
    
    func setGetWeatherResult(_ result: WeatherData) {
        getWeatherResult = result
    }
    
    func clearFlags() {
        getWeatherForCityCalled = false
        searchCitiesCalled = false
        shoulReturnEror = false
        
        lastSearchedCity = nil
        lastSearchedQuery = nil
    }
}
