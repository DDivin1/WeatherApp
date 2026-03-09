//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Dmitry Divin on 25.02.26.
//

import SwiftyJSON
import Foundation

// MARK: - Protocols
protocol INetworkService {
    func getWeatherForCity(_ cityName: String, completion: @escaping (WeatherData?) -> Void)
    func searchCities(query: String, completion: @escaping ([CityInfo]?) -> Void)
}

// MARK: - NetworkService
final class NetworkService: INetworkService {
    
    private let apiKey = "d07d47b2fdfa0861575d7c89bcb45f34"
    
    // MARK: - Public Methods
    func getWeatherForCity(_ cityName: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric&lang=ru"
        guard let url = URL(string: urlString) else {
            print("Неверный URL: \(urlString)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let weatherData = WeatherParser.parseWeather(from: data) {
                print("Погода полученна для города: \(weatherData.cityName)")
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            } else {
                print("Не удалось распарсить погоду")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func searchCities(query: String, completion: @escaping ([CityInfo]?) -> Void) {
        let queryForURL = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(queryForURL)&limit=5&appid=\(apiKey)&lang=ru"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let cities = CityParser().parseCity(from: data)
            DispatchQueue.main.async {
                completion(cities)
            }
        }.resume()
    }
}
