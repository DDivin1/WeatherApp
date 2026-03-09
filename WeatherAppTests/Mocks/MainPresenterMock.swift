//
//  MainPresenterMock.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 7.03.26.
//

@testable import WeatherApp
import Foundation

// MARK: - MainPresenterMock
final class MainPresenterMock: IMVPPresenter {
    
    // MARK: - Call Tracking
    var viewDidLoadCalled = false
    var burgerButtonPressedCalled = false
    var didReceiveWeatherCalled = false
    var didSelectCityCalled = false
    
    // MARK: - Parameter Tracking
    var lastReceivedWeather: WeatherData?
    var lastSelectedCity: CityInfo?
    
    // MARK: - IMVPPresenter Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func burgerButtonPressed() {
        burgerButtonPressedCalled = true
    }
    
    func didReceiveWeather(_ weather: WeatherApp.WeatherData) {
        didReceiveWeatherCalled = true
        lastReceivedWeather = weather
    }
    
    func didSelectCity(_ city: WeatherApp.CityInfo) {
        didSelectCityCalled = true
        lastSelectedCity = city
    }
    
    // MARK: - Helper Methods
    func clearFlags() {
        viewDidLoadCalled = false
        burgerButtonPressedCalled = false
        didReceiveWeatherCalled = false
        didSelectCityCalled = false
        
        lastSelectedCity = nil
        lastReceivedWeather = nil
    }
}
