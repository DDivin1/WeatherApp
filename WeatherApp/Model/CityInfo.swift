//
//  CityInfo.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import Foundation

// MARK: - CityInfo
final class CityInfo: Codable {
    
    // MARK: - Properties
    let name: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    // MARK: - Computed Properties
    var displayedName: String {
        return ("\(name), \(country)")
    }
    
    // MARK: - Initialization
    init(name: String, country: String, longitude: Double, latitude: Double) {
        self.name = name
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
}

// MARK: - Extension for Localization
extension CityInfo {
    var localizeCountry: String {
        let locale = Locale.current
        
        if let countryName = locale.localizedString(forRegionCode: country) {
            return countryName
        }
        return country
    }
    
    var localizedDisplayedName: String {
        return ("\(name), \(localizeCountry)")
    }
    
    var displayedNameString: String {
        return localizedDisplayedName
    }
}
