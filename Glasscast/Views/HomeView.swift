//
//  HomeView.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//

import SwiftUI

// Deprecated: the app now uses tabs (`MainTabView`) with `ForecastView`, `SearchView`, `SettingsView`.
// Keeping a minimal wrapper avoids breaking previews/old references.
struct HomeView: View {
    var body: some View {
        ForecastView()
    }
}

#Preview {
    ForecastView()
}

