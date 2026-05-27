import SwiftUI

struct ClickView: View {
    @EnvironmentObject var appState: AppState
    @State private var showModeSheet = false
    @State private var didClick = false
    @State private var clickFeedbackText = ""
    @State private var showFeedback = false

    var body: some View {
        ZStack {
            WK.paper.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button { showModeSheet = true } label: {
                        HStack(spacing: 4) {
                            ModeBadge(mode: appState.currentMode.rawValue)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(WK.accent)
                        }
                    }

                    Spacer()

                    HStack(spacing: 14) {
                        ForEach(["map", "inbox", "me"], id: \.self) { item in
                            Button(item) {
                                switch item {
                                case "map":   appState.selectedTab = .map
                                case "inbox": appState.selectedTab = .inbox
                                default:      appState.selectedTab = .me
                                }
                            }
                            .font(WK.mono(11))
                            .foregroundColor(WK.ink2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                // Instruction
                VStack(spacing: 6) {
                    Text(showFeedback ? clickFeedbackText : "See someone?")
                        .font(WK.hand(16))
                        .foregroundColor(WK.ink2)
                    if !showFeedback {
                        Text("Press & hold.")
                            .font(WK.hand(16))
                            .foregroundColor(WK.ink2)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: showFeedback)

                Spacer().frame(height: 28)

                // The Click Button
                ClickButton(
                    onPress: handleClick,
                    isActive: didClick,
                    mode: appState.currentMode
                )
                .padding(.horizontal, 20)

                Spacer().frame(height: 20)

                // Window label
                Text("18s window")
                    .font(WK.mono(11))
                    .foregroundColor(WK.ink3)

                Spacer()

                // Bottom status bar
                HStack {
                    Text("\(appState.clicksRemainingThisWeek) clicks left this week")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink2)
                    Spacer()
                    Text("\(appState.nearbyCount) nearby")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink2)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $showModeSheet) {
            ModePickerSheet()
                .environmentObject(appState)
                .presentationDetents([.medium])
        }
    }

    func handleClick() {
        guard appState.clicksRemainingThisWeek > 0 else {
            clickFeedbackText = "No clicks left this week."
            showFeedback = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showFeedback = false }
            return
        }
        withAnimation { didClick = true }
        clickFeedbackText = "Clicked. Watching for 18 seconds…"
        showFeedback = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation { didClick = false }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showFeedback = false
        }

        appState.simulateWINQ()
    }
}

// MARK: - Mode picker
struct ModePickerSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .fill(WK.ink3)
                .frame(width: 36, height: 4)
                .padding(.top, 12)

            Text("Switch Mode")
                .font(WK.emph(22))
                .padding(.top, 16)

            VStack(spacing: 12) {
                ForEach(WINQMode.allCases, id: \.self) { mode in
                    Button {
                        appState.currentMode = mode
                        dismiss()
                    } label: {
                        HStack(spacing: 14) {
                            Text(mode.emoji)
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(mode.rawValue)
                                    .font(WK.emph(20))
                                    .foregroundColor(WK.accent)
                                Text(mode.label)
                                    .font(WK.hand(14))
                                    .foregroundColor(WK.ink2)
                            }
                            Spacer()
                            if appState.currentMode == mode {
                                Image(systemName: "checkmark")
                                    .foregroundColor(WK.accent)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(14)
                        .wkBox(fill: appState.currentMode == mode ? WK.accentSoft : WK.paper)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)

            Spacer()
        }
        .background(WK.paper)
    }
}
