//
//  AuthView.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import SwiftUI
import Supabase

struct AuthView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var isLogin = true
    @State private var showPassword = false
    @State private var showCheckEmail = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 15/255, green: 25/255, blue: 40/255),
                    Color(red: 25/255, green: 30/255, blue: 60/255)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // App Icon
                Image(systemName: "cloud.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(16)
                
                // Title
                Text("Glasscast")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Clarity in every forecast")
                    .foregroundColor(.white.opacity(0.7))
                
                // Glass Card
                VStack(spacing: 20) {
                    
                    
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email address")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            
                            TextField("name@example.com", text: $authVM.email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)

                            if showPassword {
                                TextField("••••••••", text: $authVM.password)
                            } else {
                                SecureField("••••••••", text: $authVM.password)
                            }

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                    }
                    
                    // Login Button
                    Button {
                        Task {
                            await authVM.signIn()
                        }
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .disabled(authVM.isLoading)

                    // Sign Up Button
                    Button {
                        Task {
                            await authVM.signUp()
                            if authVM.errorMessage == nil {
                                showCheckEmail = true
                            }
                        }
                    } label: {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .disabled(authVM.isLoading)
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
        }
    }
}
