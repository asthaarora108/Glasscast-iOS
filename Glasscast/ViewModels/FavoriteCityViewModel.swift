//
//  FavoriteCityViewModel.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class FavoriteCityViewModel: ObservableObject {
    
    @Published var favorites: [FavoriteCity] = []
    @Published var errorMessage: String?
    
    private let service = FavoriteCityService()
    
    func loadFavorites() async {
        do {
            favorites = try await service.fetchFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    
    func isFavorite(city: String) -> Bool {
        favorites.contains {
            $0.city_name.lowercased() == city.lowercased()
        }
    }
    
    
    func addFavorite(city: String, lat: Double, lon: Double) async {
        do {
            try await service.addFavorite(
                cityName: city,
                lat: lat,
                lon: lon
            )
            await loadFavorites()   // ✅ refresh state
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func removeFavorite(id: UUID) async {
        do {
            try await service.removeFavorite(id: id)
            await loadFavorites()   // ✅ refresh state
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

