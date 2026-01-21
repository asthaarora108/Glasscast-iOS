//
//  WeatherViewModel.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//

import Foundation
import SwiftUI
import Combine


/// ViewModel managing weather state and business logic
@MainActor
final class WeatherViewModel: ObservableObject {
    // Published properties that trigger UI updates
    @AppStorage("unit") var unit: String = "metric" {
        didSet {
            // Refetch weather data when unit changes, if we have stored city and API key
            if let city = lastCity, let apiKey = lastApiKey {
                Task {
                    await fetchWeather(for: city, apiKey: apiKey)
                }
            }
        }
    }

    @Published var weather: Weather?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var forecast: [ForecastItem] = []

    // Store last used city and API key for refetching when unit changes
    private var lastCity: String?
    private var lastApiKey: String?

    // Service dependency
    private let weatherService = WeatherService()
    
    /// Fetches weather data for a given city
    /// - Parameters:
    ///   - city: Name of the city to fetch weather for
    ///   - apiKey: API key for OpenWeatherMap
    func fetchWeather(for city: String, apiKey: String) async {
        // Store city and API key for potential refetch when unit changes
        lastCity = city
        lastApiKey = apiKey

        // Set loading state
        isLoading = true
        errorMessage = nil

        do {
            let result = try await weatherService.fetchCurrentWeather(for: city, apiKey: apiKey, unit: unit)
                    self.weather = result
            forecast = try await weatherService.fetch5DayForecast(
                        city: city,
                        apiKey: apiKey,
                        unit: unit
                    )
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.weather = nil
                    self.forecast = []
                }

                isLoading = false
            }
    
    /// Fetches temperature for a specific city (used for favorites)
    /// - Parameters:
    ///   - city: Name of the city
    ///   - apiKey: API key for OpenWeatherMap
    /// - Returns: Temperature as a formatted string with unit
    func fetchTemperature(for city: String, apiKey: String) async -> String? {
        do {
            let weatherData = try await weatherService.fetchCurrentWeather(for: city, apiKey: apiKey, unit: unit)
            return "\(Int(weatherData.temperature))°\(unit == "metric" ? "C" : "F")"
        } catch {
            return nil
        }
    }

    /// Clears current weather data and error state
    func clearWeather() {
        weather = nil
        errorMessage = nil
    }
}

