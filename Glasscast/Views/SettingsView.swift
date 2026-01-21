//
//  SettingsView.swift
//  Glasscast
//
//  Created by Astha Arora on 20/01/26.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("unit") private var unit: String = "metric"
    @EnvironmentObject private var authVM: AuthViewModel

    var body: some View {
        ZStack {
            GlassBackground()

            VStack(spacing: 16) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        unitCard
                        supportCard
                        signOutButton
                    }
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .safeAreaPadding(.top)
        }
    }

    private var header: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.top, 10)
    }

    private var unitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Units")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            HStack(spacing: 10) {
                unitPill(title: "Celsius (°C)", tag: "metric")
                unitPill(title: "Fahrenheit (°F)", tag: "imperial")
            }
        }
        .glassCard()
    }

    private func unitPill(title: String, tag: String) -> some View {
        Button {
            unit = tag
        } label: {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(unit == tag ? .white : .white.opacity(0.65))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    (unit == tag ? GlassStyle.accent.opacity(0.85) : Color.white.opacity(0.06)),
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private var supportCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Support")
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))

            settingsRow(icon: "questionmark.circle", title: "Help Center", trailing: nil)
            settingsRow(icon: "doc.text", title: "Privacy Policy", trailing: "↗")
        }
        .glassCard()
    }

    private func settingsRow(icon: String, title: String, trailing: String?) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.85))
                .frame(width: 28)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            if let trailing {
                Text(trailing)
                    .foregroundColor(.white.opacity(0.6))
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.35))
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 52)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
    }

    private var signOutButton: some View {
        Button {
            Task { await authVM.signOut() }
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
                    .font(.headline)
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.red.opacity(0.10), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Color.red.opacity(0.30), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 6)
    }
}

