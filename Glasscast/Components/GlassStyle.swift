import SwiftUI

enum GlassStyle {
    static let bgTop = Color(red: 0.06, green: 0.12, blue: 0.20)
    static let bgBottom = Color(red: 0.10, green: 0.06, blue: 0.18)

    static let accent = Color(red: 0.20, green: 0.55, blue: 1.00)
    static let cardFill = Color.white.opacity(0.08)
    static let cardStroke = Color.white.opacity(0.14)
}

struct GlassBackground: View {
    var body: some View {
        LinearGradient(
            colors: [GlassStyle.bgTop, GlassStyle.bgBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(GlassStyle.cardStroke, lineWidth: 1)
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }
}


