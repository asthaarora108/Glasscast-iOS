//
//  Weather.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//

import Foundation

/// Model representing weather data
struct Weather {
    let temperature: Double
    let condition: String
    let conditionDescription: String
    let humidity: Int
    let windSpeed: Double
    let lat: Double
    let lon: Double
}

/// API response structure for OpenWeatherMap
struct WeatherResponse: Codable {
    let weather: [WeatherInfo]
    let main: MainWeather
    let wind: Wind
    let coord: Coord   // ✅ ADD

        struct Coord: Codable {
            let lat: Double
            let lon: Double
        }
    
    
    struct WeatherInfo: Codable {
        let main: String
        let description: String
    }
    
    struct MainWeather: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

/// Extension to convert API response to Weather model
extension WeatherResponse {
    func toWeather() -> Weather {
        let weatherInfo = weather.first ?? WeatherInfo(main: "Unknown", description: "Unknown")
        return Weather(
            temperature: main.temp,
            condition: weatherInfo.main,
            conditionDescription: weatherInfo.description,
            humidity: main.humidity,
            windSpeed: wind.speed,
            lat: coord.lat,     // ✅
            lon: coord.lon
        )
    }
}

