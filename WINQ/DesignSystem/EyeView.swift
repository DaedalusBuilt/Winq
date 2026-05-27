import SwiftUI

// MARK: - Eye Shape (the WINQ logo / button shape)
struct EyeShape: Shape {
    var blink: Bool = false
    var animatableData: Bool { get { blink } set { } }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        let cx = rect.midX, cy = rect.midY

        if blink {
            // Closed eye — top arc only
            path.move(to: CGPoint(x: rect.minX + w * 0.05, y: cy))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - w * 0.05, y: cy),
                control: CGPoint(x: cx, y: cy - h * 0.35)
            )
        } else {
            // Open eye — almond shape
            path.move(to: CGPoint(x: rect.minX + w * 0.05, y: cy))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - w * 0.05, y: cy),
                control: CGPoint(x: cx, y: rect.minY - h * 0.08)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + w * 0.05, y: cy),
                control: CGPoint(x: cx, y: rect.maxY + h * 0.08)
            )
            path.closeSubpath()
        }
        return path
    }
}

// MARK: - Eye Icon (small, for nav / buttons)
struct EyeIcon: View {
    var size: CGFloat = 32
    var stroke: Color = WK.ink
    var filled: Bool = false
    var blinking: Bool = false

    var body: some View {
        let h = size * 0.62
        ZStack {
            EyeShape(blink: blinking)
                .stroke(stroke, style: StrokeStyle(lineWidth: size * 0.035, lineJoin: .round))
                .frame(width: size, height: h)

            if !blinking {
                // Iris
                Circle()
                    .stroke(stroke, lineWidth: size * 0.025)
                    .frame(width: size * 0.28, height: size * 0.28)

                if filled {
                    Circle()
                        .fill(stroke)
                        .frame(width: size * 0.28, height: size * 0.28)
                    // Highlight
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.1, height: size * 0.1)
                        .offset(x: size * 0.05, y: -size * 0.05)
                }
            }
        }
        .frame(width: size, height: h)
    }
}

// MARK: - The Big Click Button
struct ClickButton: View {
    var onPress: () -> Void
    var isActive: Bool = false
    var mode: WINQMode = .winq

    @State private var isPressing = false
    @State private var blinking = false
    @State private var pulseScale: CGFloat = 1
    @State private var fillProgress: CGFloat = 0

    var modeColor: Color {
        switch mode {
        case .winq: return WK.accent
        case .finq: return Color(hex: "#5BA4CF")
        case .binq: return Color(hex: "#3DAA7A")
        }
    }

    var body: some View {
        ZStack {
            // Outer pulse ring
            EyeShape()
                .stroke(modeColor.opacity(0.25), lineWidth: 2)
                .frame(width: 220, height: 220 * 0.62)
                .scaleEffect(isPressing ? 1.12 : 1)

            // Fill background
            EyeShape()
                .fill(isActive ? modeColor : WK.accentSoft)
                .frame(width: 200, height: 200 * 0.62)
                .animation(.easeInOut(duration: 0.3), value: isActive)

            // Outline
            EyeShape()
                .stroke(modeColor, style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                .frame(width: 200, height: 200 * 0.62)

            // Inner eye icon
            EyeIcon(
                size: isPressing ? 90 : 100,
                stroke: isActive ? WK.paper : modeColor,
                filled: isActive,
                blinking: blinking
            )
            .animation(.spring(response: 0.2), value: isPressing)
        }
        .scaleEffect(isPressing ? 0.93 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressing)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressing {
                        isPressing = true
                        WK.hapticClick()
                    }
                }
                .onEnded { _ in
                    isPressing = false
                    withAnimation(.easeInOut(duration: 0.15)) { blinking = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeInOut(duration: 0.15)) { blinking = false }
                        onPress()
                    }
                }
        )
    }
}

// MARK: - Tab Bar Icons
struct EyeTabIcon: View {
    var body: some View {
        Image(systemName: "eye")
    }
}
