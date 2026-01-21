//
//  FavoriteCity.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import Foundation

struct FavoriteCity: Identifiable, Codable, Equatable {
    let id: UUID
    let user_id: UUID?
    let city_name: String
    let lat: Double
    let lon: Double
    let created_at: String?

    static func == (lhs: FavoriteCity, rhs: FavoriteCity) -> Bool {
        lhs.id == rhs.id
    }
}

struct FavoriteCityInsert: Codable {
    let user_id: UUID
    let city_name: String
    let lat: Double
    let lon: Double
}


