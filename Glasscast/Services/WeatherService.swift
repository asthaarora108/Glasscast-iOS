//
//  WeatherService.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//

import Foundation

/// Service responsible for fetching weather data from API
class WeatherService {
    // Base URL for OpenWeatherMap API
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    /// Fetches weather data for a given city
    /// - Parameters:
    ///   - city: Name of the city
    ///   - apiKey: API key for OpenWeatherMap (should be stored securely)
    /// - Returns: Weather model with current weather data
    /// - Throws: NetworkError if the request fails
    func fetchCurrentWeather(for city: String, apiKey: String, unit: String) async throws -> Weather {

        // Construct URL with query parameters
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: unit) // Use metric for Celsius
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // Perform network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // Decode JSON response
        do {
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return weatherResponse.toWeather()
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    func fetch5DayForecast(
        city: String,
        apiKey: String,
        unit: String
    ) async throws -> [ForecastItem] {

        let url = URL(string:
                "https://api.openweathermap.org/data/2.5/forecast"
            )!

            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: unit)
            ]

            let (data, _) = try await URLSession.shared.data(
                from: components.url!
            )

            let response = try JSONDecoder().decode(ForecastResponse.self, from: data)

            // Pick 1 forecast per day (every ~24h)
            return stride(from: 0, to: response.list.count, by: 8)
                .map { response.list[$0] }
        }
}

/// Custom error types for network operations
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

