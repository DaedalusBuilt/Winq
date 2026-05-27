import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var step = 0

    var body: some View {
        ZStack {
            WK.paper.ignoresSafeArea()

            switch step {
            case 0:  OnboardingWelcomeView { step = 1 }
            case 1:  OnboardingPhotosView  { step = 2 }
            case 2:  OnboardingVerifyView  { step = 3 }
            case 3:  OnboardingButtonView  {
                withAnimation { appState.hasCompletedOnboarding = true }
            }
            default: EmptyView()
            }
        }
        .animation(.spring(response: 0.4), value: step)
    }
}

// MARK: - Step 1: Welcome
struct OnboardingWelcomeView: View {
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Eye logo
            EyeIcon(size: 120, stroke: WK.accent, filled: true)
                .padding(.bottom, 16)

            // WINQ wordmark
            Text("WINQ")
                .font(WK.emph(64))
                .foregroundColor(WK.accent)
                .kerning(4)

            Text("Timing is everything.")
                .font(WK.hand(18))
                .foregroundColor(WK.ink2)
                .padding(.top, 6)

            Spacer()

            VStack(spacing: 10) {
                Button("Get started") { onNext() }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true, size: .lg))

                Button("I already have an account") {}
                    .buttonStyle(WKButtonStyle(fullWidth: true, size: .lg))
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 48)
        }
    }
}

// MARK: - Step 2: Photos
struct OnboardingPhotosView: View {
    var onNext: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("step 2 of 4 ─ ─ ─ ─")
                    .font(WK.mono(11))
                    .foregroundColor(WK.ink3)

                Text("Two photos.\nThat's it.")
                    .font(WK.emph(28))
                    .foregroundColor(WK.ink)
                    .lineSpacing(2)

                Text("One for the world. One for the street.")
                    .font(WK.hand(14))
                    .foregroundColor(WK.ink2)

                WavyDivider()

                // Photo 1
                VStack(alignment: .leading, spacing: 8) {
                    Text("01 · PROFILE PHOTO")
                        .font(WK.mono(10))
                        .foregroundColor(WK.ink3)
                    HStack(spacing: 12) {
                        PhotoSlot(label: "tap to add", height: 70, radius: 999)
                            .frame(width: 70)
                        Text("Any photo of you.\nSmall + circular.")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                            .lineSpacing(3)
                    }
                }

                // Photo 2
                VStack(alignment: .leading, spacing: 8) {
                    Text("02 · \"IN THE WILD\" PHOTO")
                        .font(WK.mono(10))
                        .foregroundColor(WK.ink3)
                    PhotoSlot(
                        label: "full-body · outdoors · candid\n— how you actually look out there —",
                        height: 160
                    )
                    HStack(spacing: 16) {
                        ForEach(["Walking", "In transit", "Taken by someone else"], id: \.self) { opt in
                            HStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(WK.ink3, lineWidth: 1)
                                    .frame(width: 12, height: 12)
                                Text(opt)
                                    .font(WK.mono(9))
                                    .foregroundColor(WK.ink3)
                            }
                        }
                    }
                }

                Spacer().frame(height: 20)

                Button("Continue →") { onNext() }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Step 3: Verify
struct OnboardingVerifyView: View {
    var onNext: () -> Void
    @State private var scanActive = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("step 3 of 4 ─ ─ ─ ─")
                    .font(WK.mono(11))
                    .foregroundColor(WK.ink3)

                Text("Prove you're you.")
                    .font(WK.emph(28))
                    .foregroundColor(WK.ink)

                Text("18+ required. Catfish-proof, by design.")
                    .font(WK.hand(14))
                    .foregroundColor(WK.ink2)

                // Face scan circle
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                        .foregroundColor(WK.ink)
                        .frame(width: 180, height: 180)

                    Text("face scan\npreview")
                        .font(WK.mono(12))
                        .foregroundColor(WK.ink2)
                        .multilineTextAlignment(.center)

                    // Corner brackets
                    ForEach([(-1.0, -1.0), (1.0, -1.0), (-1.0, 1.0), (1.0, 1.0)], id: \.0) { hSign, vSign in
                        Path { p in
                            let s: CGFloat = 20
                            let ox: CGFloat = hSign * 90 + hSign * 4
                            let oy: CGFloat = vSign * 90 + vSign * 4
                            p.move(to: CGPoint(x: ox - hSign * s, y: oy))
                            p.addLine(to: CGPoint(x: ox, y: oy))
                            p.addLine(to: CGPoint(x: ox, y: oy - vSign * s))
                        }
                        .stroke(WK.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)

                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Text("📷")
                        Text("Scan face")
                            .font(WK.hand(14))
                            .foregroundColor(WK.ink)
                        Spacer()
                    }
                    .padding(12)
                    .wkBox(fill: WK.paper)

                    HStack(spacing: 10) {
                        Text("🪪")
                        Text("Upload ID")
                            .font(WK.hand(14))
                            .foregroundColor(WK.ink)
                        Spacer()
                    }
                    .padding(12)
                    .wkBox(fill: WK.paper)
                }

                Spacer().frame(height: 20)

                Button("Verify me") { onNext() }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Step 4: Button
struct OnboardingButtonView: View {
    var onNext: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("step 4 of 4 ─ ─ ─ ─")
                    .font(WK.mono(11))
                    .foregroundColor(WK.ink3)

                Text("Get your button.")
                    .font(WK.emph(28))
                    .foregroundColor(WK.ink)

                Text("Have it ready. The moment is fast.")
                    .font(WK.hand(14))
                    .foregroundColor(WK.ink2)

                // Stick-on button
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(WK.accentSoft)
                            .frame(width: 64, height: 64)
                        EyeIcon(size: 42, stroke: WK.accent)
                    }
                    .overlay(Circle().stroke(WK.accent, lineWidth: 2))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Stick-on button")
                            .font(WK.hand(15)).fontWeight(.bold)
                            .foregroundColor(WK.ink)
                        Text("Physical hardware · $—")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                    }
                    Spacer()
                    Button("Order") {}
                        .buttonStyle(WKButtonStyle(size: .sm))
                }
                .padding(14)
                .wkBox(fill: WK.paper)

                // Action button
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(WK.ink, lineWidth: 1.5)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text("action\nbtn")
                                .font(WK.mono(9))
                                .foregroundColor(WK.ink2)
                                .multilineTextAlignment(.center)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Action button")
                            .font(WK.hand(15)).fontWeight(.bold)
                            .foregroundColor(WK.ink)
                        Text("Reconfigure your iPhone side button")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                    }
                    Spacer()
                }
                .padding(14)
                .wkBox(dashed: true)

                // Lock screen widget
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(WK.ink, lineWidth: 1.5)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text("lock\nscreen")
                                .font(WK.mono(9))
                                .foregroundColor(WK.ink2)
                                .multilineTextAlignment(.center)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Lock-screen widget")
                            .font(WK.hand(15)).fontWeight(.bold)
                            .foregroundColor(WK.ink)
                        Text("No hardware needed")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                    }
                    Spacer()
                }
                .padding(14)
                .wkBox(dashed: true)

                Spacer().frame(height: 20)

                Button("Finish setup") { onNext() }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 40)
        }
    }
}
