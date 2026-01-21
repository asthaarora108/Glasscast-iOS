//
//  GlasscastApp.swift
//  Glasscast
//
//  Created by Astha Arora on 19/01/26.
//
import SwiftUI

@main
struct GlasscastApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .onOpenURL { _ in
                    Task {
                        await authVM.checkSession()
                    }
                }
        }
    }
}


