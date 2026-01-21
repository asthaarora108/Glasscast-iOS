import SwiftUI

struct ForecastView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName = "London"
    @State private var apiKey = ""
    @State private var showApiKeyInput = true
    @AppStorage("unit") private var unit: String = "metric"

    var body: some View {
        ZStack {
            GlassBackground()

            VStack(spacing: 20) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        if showApiKeyInput {
                            apiKeyCard
                        } else {
                            searchRow
                            content
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .safeAreaPadding(.top)
        }
        .onChange(of: unit) { _, _ in
            // Refetch weather data when unit changes, if we have stored data
            if !showApiKeyInput, !cityName.isEmpty, !apiKey.isEmpty {
                Task { await viewModel.fetchWeather(for: cityName, apiKey: apiKey) }
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Glasscast")
                .font(.system(size: 34, weight: .bold))
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
                Task { await viewModel.fetchWeather(for: cityName, apiKey: apiKey) }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
            .buttonStyle(.borderedProminent)
            .tint(GlassStyle.accent)
            .disabled(apiKey.isEmpty)

            Text("Get your free API key from openweathermap.org")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.leading)
        }
        .glassCard()
    }

    private var searchRow: some View {
        HStack(spacing: 12) {
            TextField("Search city", text: $cityName)
                .textInputAutocapitalization(.words)
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
                Task { await viewModel.fetchWeather(for: cityName, apiKey: apiKey) }
            } label: {
                Text("Search")
                    .font(.headline)
                    .frame(width: 92, height: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(GlassStyle.accent)
        }
    }

    private var content: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.22), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            if let weather = viewModel.weather {
                weatherCard(weather: weather)
            }

            if !viewModel.forecast.isEmpty {
                forecastStrip
            }
        }
    }

    private func weatherCard(weather: Weather) -> some View {
        VStack(spacing: 18) {
            Image(systemName: conditionIcon(for: weather.condition))
                .font(.system(size: 56))
                .foregroundColor(.white)

            Text("\(Int(weather.temperature))°\(viewModel.unit == "metric" ? "C" : "F")")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(.white)

            Text(weather.conditionDescription.capitalized)
                .font(.title3)
                .foregroundColor(.white.opacity(0.85))

            Divider().overlay(Color.white.opacity(0.2))

            HStack(spacing: 28) {
                VStack(spacing: 6) {
                    Image(systemName: "humidity")
                    Text("\(weather.humidity)%")
                        .font(.headline)
                }
                VStack(spacing: 6) {
                    Image(systemName: "wind")
                    Text("\(Int(weather.windSpeed)) km/h")
                        .font(.headline)
                }
            }
            .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 28)
    }

    private var forecastStrip: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("5-Day Forecast")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.forecast) { item in
                        VStack(spacing: 8) {
                            Text(Date(timeIntervalSince1970: item.dt), style: .date)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.75))

                            Image(systemName: "cloud.fill")
                                .foregroundColor(.white.opacity(0.9))

                            Text("\(Int(item.main.temp))°\(unit == "metric" ? "C" : "F")")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .glassCard()
    }

    private func conditionIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "sun.max.fill"
        case "clouds": return "cloud.fill"
        case "rain": return "cloud.rain.fill"
        case "drizzle": return "cloud.drizzle.fill"
        case "thunderstorm": return "cloud.bolt.fill"
        case "snow": return "cloud.snow.fill"
        case "mist", "fog": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}


