//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import Foundation

// MARK: - Constants
private enum Constants {
    static let temperatureUnit = "°C"
    static let windSpeedUnit = "m/s"
    static let feelsLikeText = "Feels like:"
    static let windText = "Wind:"
    
    static let windDirectionOffset: Double = 22.5
    static let windDirectionDivisor: Double = 45.0
    static let windDirectionMask = 7
    
    static let windDirections = [
        "N".localized,
        "NE".localized,
        "E".localized,
        "SE".localized,
        "S".localized,
        "SW".localized,
        "W".localized,
        "NW".localized
    ]
}

final class WeatherData: Codable {
    
    // MARK: - Properties
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let windSpeed: Double
    let windDirection: Int
    
    // MARK: - Computed Properties
    var temperatureString: String {
        return "\(Int(temperature))\(Constants.temperatureUnit)"
    }
    
    var feelsLikeString: String {
        return "\(Constants.feelsLikeText.localized) \(Int(feelsLike))\(Constants.temperatureUnit)"
    }
    
    var windString: String {
        return "\(Constants.windText.localized)\(Int(windSpeed)) \(Constants.windSpeedUnit.localized), \(windDirectionString)"
    }
    
    private var windDirectionString: String {
        let index = Int((Double(windDirection) + Constants.windDirectionOffset) / Constants.windDirectionDivisor) & Constants.windDirectionMask
        return Constants.windDirections[index]
    }
    
    // MARK: - Initialization
    init(cityName: String,
         temperature: Double,
         feelsLike: Double,
         description: String,
         windSpeed: Double,
         windDirection: Int) {
        self.cityName = cityName
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.description = description
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
}
