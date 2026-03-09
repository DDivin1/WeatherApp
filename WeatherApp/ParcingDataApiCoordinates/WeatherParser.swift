//
//  WeatherParser.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import Foundation

final class WeatherParser {
    
    static func parseWeather(from data: Data) -> WeatherData? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let main = json["main"] as? [String: Any],
               let weatherArray = json["weather"] as? [[String: Any]],
               let weather = weatherArray.first,
               let wind = json["wind"] as? [String: Any],
               let name = json["name"] as? String {
                
                let temp = main["temp"] as? Double ?? 0
                let feelsLike = main["feels_like"] as? Double ?? 0
                let description = weather["description"] as? String ?? ""
                let windSpeed = wind["speed"] as? Double ?? 0
                let windDeg = wind["deg"] as? Int ?? 0
                
                let weatherData = WeatherData(
                    cityName: name,
                    temperature: temp,
                    feelsLike: feelsLike,
                    description: description,
                    windSpeed: windSpeed,
                    windDirection: windDeg
                )
                
                print("Парсинг успешен: \(weatherData.cityName), \(weatherData.temperature)°C")
                return weatherData
            }
        } catch {
            print("Ошибка парсинга погоды: \(error.localizedDescription)")
        }
        return nil
    }
}
