//
//  AuthViewModel.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

//
//  AuthViewModel.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import Foundation
import Supabase
import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Input
    @Published var email = ""
    @Published var password = ""

    // MARK: - State
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    // MARK: - Init
    init() {
        // Don't force sign-out on every launch; it breaks persistence and makes login feel "not working".
        checkSession()
    }


    // MARK: - Session
    func checkSession() {
        isAuthenticated = supabase.auth.currentSession != nil
    }

    // MARK: - Sign Up
    func signUp() async {
        isLoading = true
        errorMessage = nil

        do {
            try await supabase.auth.signUp(
                email: email,
                password: password
            )
            errorMessage = "Check your email to confirm your account."
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Sign In
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await supabase.auth.signIn(
                email: email,
                password: password
            )
            checkSession()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() async {
        try? await supabase.auth.signOut()
        isAuthenticated = false
    }
}
