import SwiftUI

struct SearchView: View {
    @StateObject private var favoriteVM = FavoriteCityViewModel()
    @StateObject private var weatherVM = WeatherViewModel()

    @State private var apiKey = ""
    @State private var showApiKeyInput = true
    @AppStorage("unit") private var unit: String = "metric"

    @State private var query = ""
    @State private var lastSearchedCity: String?
    @State private var favoriteTemperatures: [String: String] = [:]

    var body: some View {
        ZStack {
            GlassBackground()

            VStack(spacing: 16) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if showApiKeyInput {
                            apiKeyCard
                        } else {
                            searchBar
                            favoritesSection
                            resultsSection
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .safeAreaPadding(.top)
        }
        .task {
            await favoriteVM.loadFavorites()
            await fetchTemperaturesForFavorites()
        }
        .onChange(of: unit) { _, _ in
            // Refetch weather data when unit changes, if we have stored data
            if !showApiKeyInput, let city = lastSearchedCity, !apiKey.isEmpty {
                Task { await weatherVM.fetchWeather(for: city, apiKey: apiKey) }
            }
            // Refresh temperatures for favorite cities
            Task { await fetchTemperaturesForFavorites() }
        }
        .onChange(of: favoriteVM.favorites) { _, _ in
            // Fetch temperatures when favorites change
            Task { await fetchTemperaturesForFavorites() }
        }
    }

    private var header: some View {
        HStack {
            Text("Search Cities")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.top, 10)
    }

    private var apiKeyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter API Key")
                .font(.headline)
                .foregroundColor(.white)

            TextField("OpenWeatherMap API Key", text: $apiKey)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
                .foregroundColor(.white)

            Button {
                guard !apiKey.isEmpty else { return }
                showApiKeyInput = false
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(GlassStyle.accent)
            .disabled(apiKey.isEmpty)
        }
        .glassCard()
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))

            TextField("Search", text: $query)
                .foregroundColor(.white)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .onSubmit { search(query) }

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Favorites")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
            }

            if favoriteVM.favorites.isEmpty {
                Text("No favorites yet. Tap + to add.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.vertical, 6)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(favoriteVM.favorites) { city in
                            FavoriteCityCard(
                                title: city.city_name,
                                subtitle: nil,
                                temperature: favoriteTemperatures[city.city_name]
                            ) {
                                Task {
                                    await favoriteVM.removeFavorite(id: city.id)
                                }
                            }
                            .onTapGesture {
                                search(city.city_name)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .glassCard()
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Search Results")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            if let error = favoriteVM.errorMessage {
                Text(error)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.22), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            if weatherVM.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }

            if let err = weatherVM.errorMessage {
                Text(err)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.22), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            if let city = lastSearchedCity {
                SearchResultRow(
                    city: city,
                    temperatureText: weatherVM.weather.map { "\(Int($0.temperature))°\(unit == "metric" ? "C" : "F")" },
                    isFavorite: favoriteVM.isFavorite(city: city)
                ) {
                    Task {
                        if let fav = favoriteVM.favorites.first(where: { $0.city_name.lowercased() == city.lowercased() }) {
                            await favoriteVM.removeFavorite(id: fav.id)
                        } else if let w = weatherVM.weather {
                            await favoriteVM.addFavorite(city: city, lat: w.lat, lon: w.lon)
                        }
                    }
                }
            } else {
                Text("Search a city to see results here.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.vertical, 6)
            }
        }
        .glassCard()
    }

    private func search(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        lastSearchedCity = trimmed
        Task {
            await weatherVM.fetchWeather(for: trimmed, apiKey: apiKey)
        }
    }

    private func fetchTemperaturesForFavorites() async {
        guard !apiKey.isEmpty else { return }

        for city in favoriteVM.favorites {
            let temperature = await weatherVM.fetchTemperature(for: city.city_name, apiKey: apiKey)
            favoriteTemperatures[city.city_name] = temperature
        }
    }
}

private struct FavoriteCityCard: View {
    let title: String
    let subtitle: String?
    let temperature: String?
    let onRemove: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                Spacer()
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                if let temperature {
                    Text(temperature)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .frame(width: 160, height: 110)
            .padding(14)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )

            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.white.opacity(0.10), in: Circle())
            }
            .padding(10)
        }
    }
}

private struct SearchResultRow: View {
    let city: String
    let temperatureText: String?
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(city)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Tap + to favorite")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
            if let temperatureText {
                Text(temperatureText)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.85))
            }

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "checkmark" : "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(GlassStyle.accent.opacity(0.9), in: Circle())
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
    }
}


