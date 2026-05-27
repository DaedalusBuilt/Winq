import SwiftUI

// MARK: - WINQ Design System
// Translated directly from wireframe-kit.jsx

enum WK {
    // Colors
    static let ink      = Color(hex: "#1A1A1A")
    static let ink2     = Color(hex: "#4A4A4A")
    static let ink3     = Color(hex: "#9A9A9A")
    static let paper    = Color(hex: "#FAF7F0")
    static let paperDim = Color(hex: "#F0EDE4")
    static let accent   = Color(hex: "#E8654B")   // coral — the click
    static let accentSoft = Color(hex: "#FDE4DC")
    static let bg       = Color(hex: "#F0EEE9")

    // Corner radius
    static let radius: CGFloat = 14
    static let radiusSm: CGFloat = 8
    static let radiusLg: CGFloat = 24

    // Fonts
    static func emph(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .custom("Caveat-Bold", size: size).weight(weight)
    }
    static func hand(_ size: CGFloat) -> Font {
        .custom("PatrickHand-Regular", size: size)
    }
    static func mono(_ size: CGFloat) -> Font {
        .system(size: size, design: .monospaced)
    }

    // Haptics
    static func hapticSuccess() {
        let g = UINotificationFeedbackGenerator()
        g.notificationOccurred(.success)
    }
    static func hapticClick() {
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            let g2 = UIImpactFeedbackGenerator(style: .medium)
            g2.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let g3 = UIImpactFeedbackGenerator(style: .light)
            g3.impactOccurred()
        }
    }
}

// MARK: - Color from hex
extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Shared button style
struct WKButtonStyle: ButtonStyle {
    var fill: Color = .clear
    var stroke: Color = WK.ink
    var foreground: Color = WK.ink
    var fullWidth: Bool = false
    var size: WKButtonSize = .md
    var dashed: Bool = false

    enum WKButtonSize { case sm, md, lg }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(WK.hand(size == .sm ? 13 : size == .lg ? 18 : 15))
            .foregroundColor(foreground)
            .padding(.horizontal, size == .sm ? 14 : size == .lg ? 24 : 18)
            .padding(.vertical, size == .sm ? 7 : size == .lg ? 13 : 9)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(fill)
            .overlay(
                RoundedRectangle(cornerRadius: 999)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: dashed ? [5, 3] : []))
                    .foregroundColor(stroke)
            )
            .clipShape(RoundedRectangle(cornerRadius: 999))
            .shadow(color: fill == .clear ? .clear : .black.opacity(0.12), radius: 0, x: 2, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

// Convenience view modifiers
extension View {
    func wkCard(fill: Color = WK.paper, radius: CGFloat = WK.radius) -> some View {
        self
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(RoundedRectangle(cornerRadius: radius).stroke(WK.ink, lineWidth: 1.5))
            .shadow(color: .black.opacity(0.07), radius: 0, x: 3, y: 3)
    }

    func wkBox(fill: Color = .clear, radius: CGFloat = WK.radiusSm, dashed: Bool = false) -> some View {
        self
            .background(fill)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: dashed ? [5, 3] : []))
                    .foregroundColor(WK.ink)
            )
    }
}

// MARK: - Wavy divider
struct WavyDivider: View {
    var color: Color = WK.ink
    var body: some View {
        Canvas { ctx, size in
            var path = Path()
            let step: CGFloat = 20
            path.move(to: CGPoint(x: 0, y: size.height / 2))
            var x: CGFloat = 0
            while x < size.width {
                path.addQuadCurve(
                    to: CGPoint(x: x + step, y: size.height / 2),
                    control: CGPoint(x: x + step / 2, y: x.truncatingRemainder(dividingBy: 40) == 0 ? 0 : size.height)
                )
                x += step
            }
            ctx.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 1.5))
        }
        .frame(height: 6)
        .opacity(0.5)
    }
}

// MARK: - Photo slot placeholder
struct PhotoSlot: View {
    var label: String = "photo"
    var height: CGFloat = 120
    var radius: CGFloat = WK.radiusSm
    var body: some View {
        ZStack {
            Color(hex: "#F0EDE4")
            // diagonal stripes via Canvas
            Canvas { ctx, size in
                let stripe: CGFloat = 12
                var i: CGFloat = -size.height
                while i < size.width + size.height {
                    var p = Path()
                    p.move(to: CGPoint(x: i, y: 0))
                    p.addLine(to: CGPoint(x: i + size.height, y: size.height))
                    ctx.stroke(p, with: .color(WK.paper), lineWidth: stripe * 0.5)
                    i += stripe
                }
            }
            Text(label)
                .font(WK.mono(10))
                .foregroundColor(WK.ink2)
                .multilineTextAlignment(.center)
                .padding(6)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: radius))
        .overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5, 3]))
                .foregroundColor(WK.ink)
        )
    }
}

// MARK: - Mode badge
struct ModeBadge: View {
    var mode: String = "WINQ"
    var body: some View {
        Text(mode)
            .font(WK.emph(22))
            .foregroundColor(WK.accent)
            .kerning(1)
    }
}
