//
//  ContentView.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//

import SwiftUI

// NOTE: This file exists outside `Views/` and duplicates `Views/ContentView.swift`.
// It is not referenced by the app entry point. Keep it named differently to avoid
// "Invalid redeclaration of 'ContentView'" build errors.
struct LegacyContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    LegacyContentView()
}
