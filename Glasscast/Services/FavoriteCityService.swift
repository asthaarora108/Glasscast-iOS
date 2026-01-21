//
//  FavoriteCityService.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import Foundation
import Supabase

@MainActor
final class FavoriteCityService {

    func fetchFavorites() async throws -> [FavoriteCity] {
        guard let userId = supabase.auth.currentSession?.user.id else {
            return []
        }

        let response = try await supabase
            .from("favorite_cities")
            .select()
            .eq("user_id", value: userId)
            .order("created_at", ascending: false)
            .execute()

        let decoder = JSONDecoder()
        return try decoder.decode([FavoriteCity].self, from: response.data)
    }

    func addFavorite(cityName: String, lat: Double, lon: Double) async throws {
        guard let userId = supabase.auth.currentSession?.user.id else {
            throw NSError(domain: "FavoriteCityService", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "You must be logged in to add favorites."
            ])
        }

        let newCity = FavoriteCityInsert(
            user_id: userId,
            city_name: cityName,
            lat: lat,
            lon: lon
        )

        try await supabase
            .from("favorite_cities")
            .insert(newCity)
            .execute()
    }

    func removeFavorite(id: UUID) async throws {
        try await supabase
            .from("favorite_cities")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
