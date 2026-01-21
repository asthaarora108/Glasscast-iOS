//
//  RootView.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        if authVM.isAuthenticated {
            MainTabView()
                .environmentObject(authVM)
        } else {
            AuthView()
        }
    }
}

