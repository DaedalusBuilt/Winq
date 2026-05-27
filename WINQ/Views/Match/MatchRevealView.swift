import SwiftUI

struct MatchRevealView: View {
    let match: WINQMatch
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var appeared = false

    var body: some View {
        ZStack {
            WK.paper.ignoresSafeArea()

            VStack(spacing: 0) {
                // Back / timestamp
                HStack {
                    Button { dismiss() } label: {
                        Text("← inbox")
                            .buttonStyle(WKButtonStyle(size: .sm))
                            .padding(8)
                            .wkBox(radius: 999)
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink)
                    }
                    Spacer()
                    Text(match.location)
                        .font(WK.mono(10))
                        .foregroundColor(WK.ink2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 16)

                // Headline
                VStack(spacing: 4) {
                    Text("you both")
                        .font(WK.emph(36))
                        .foregroundColor(WK.accent)
                    Text("WINQ'd.")
                        .font(WK.emph(36))
                        .foregroundColor(WK.accent)
                    Text("Both wanted the same thing.")
                        .font(WK.hand(15))
                        .foregroundColor(WK.ink2)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
                .animation(.spring(response: 0.5).delay(0.1), value: appeared)

                Spacer().frame(height: 20)

                // Profile card — slightly rotated, sketchy
                VStack(alignment: .leading, spacing: 10) {
                    PhotoSlot(label: "profile photo\nrevealed on match", height: 200, radius: 10)

                    Text("\(match.name), \(match.age)")
                        .font(WK.emph(24))
                        .foregroundColor(WK.ink)

                    Text("\(match.distance) · clicked \(match.timeAgo)")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink2)
                }
                .padding(16)
                .wkCard()
                .rotationEffect(.degrees(-1))
                .padding(.horizontal, 28)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.9)
                .animation(.spring(response: 0.5).delay(0.25), value: appeared)

                Spacer()

                // Haptic note
                Text("▮ unique haptic confirmation ▮")
                    .font(WK.mono(9))
                    .foregroundColor(WK.ink3)
                    .padding(.bottom, 8)

                // Action buttons
                HStack(spacing: 12) {
                    Button("Decline") { dismiss() }
                        .buttonStyle(WKButtonStyle(dashed: true, fullWidth: true))

                    Button("Say hi →") {
                        WK.hapticSuccess()
                        dismiss()
                    }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            WK.hapticClick()
            withAnimation { appeared = true }
        }
    }
}

// MARK: - Group Match
struct GroupMatchView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selected: Int? = nil

    let total = 14
    let shown = 9

    var body: some View {
        ZStack {
            WK.paper.ignoresSafeArea()
            VStack(spacing: 14) {
                // Handle
                RoundedRectangle(cornerRadius: 2).fill(WK.ink3)
                    .frame(width: 36, height: 4).padding(.top, 14)

                Text("GROUP · concert · \(total) clicks · 18s window")
                    .font(WK.mono(10))
                    .foregroundColor(WK.ink3)

                VStack(alignment: .leading, spacing: 4) {
                    Text("A lot of people")
                        .font(WK.emph(26))
                    Text("clicked you back.")
                        .font(WK.emph(26))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                Text("Pick 1 to message. The rest stay anonymous.")
                    .font(WK.hand(14))
                    .foregroundColor(WK.ink2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                // 3x3 grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(0..<shown, id: \.self) { i in
                        ZStack {
                            PhotoSlot(label: "#\(i+1)", height: 80, radius: 10)
                            if selected == i {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(WK.accent, lineWidth: 2.5)
                            }
                        }
                        .onTapGesture { selected = i }
                    }
                }
                .padding(.horizontal, 20)

                if let s = selected {
                    Text("✓ Selected · #\(s+1)")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                }

                Spacer()

                VStack(spacing: 10) {
                    Button("Send message request →") {
                        WK.hapticSuccess()
                        dismiss()
                    }
                    .buttonStyle(WKButtonStyle(fill: WK.accent, stroke: WK.accent,
                                               foreground: WK.paper, fullWidth: true))
                    .disabled(selected == nil)
                    .opacity(selected == nil ? 0.5 : 1)

                    Button("Skip · save for later") { dismiss() }
                        .buttonStyle(WKButtonStyle(dashed: true, fullWidth: true))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(WK.paper)
    }
}
