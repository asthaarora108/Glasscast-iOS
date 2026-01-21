//
//  Forecast.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable, Identifiable {
    let id = UUID()
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [ForecastWeather]
}

struct ForecastMain: Decodable {
    let temp: Double
}

struct ForecastWeather: Decodable {
    let main: String
    let icon: String
}

