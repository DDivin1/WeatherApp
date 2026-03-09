//
//  CityParser.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import SwiftyJSON
import Foundation


final class CityParser {
    func parseCity (from data: Data) -> [CityInfo] {
        let json = JSON(data)
        var cities: [CityInfo] = []
        for (_, item) in json {
            if let name = item["name"].string,
               let country = item["country"].string,
               let lon = item["lon"].double,
               let lat = item["lat"].double {
                
                let city = CityInfo( name: name.localized,
                                     country: country,
                                     longitude: lon,
                                     latitude: lat)
                cities.append(city)
            }
        }
        return cities
    }
}
