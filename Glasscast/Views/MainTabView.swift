import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        TabView {
            ForecastView()
                .tabItem {
                    Label("Home", systemImage: "cloud.sun.fill")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(GlassStyle.accent)
    }
}


