import SwiftUI

struct InboxView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var selectedMatch: WINQMatch?
    @State private var showGroup = false

    let tabs = ["Mutual", "Daily Clicks", "Group"]

    var mutualMatches: [WINQMatch] { appState.matches.filter { !$0.isGroup } }
    var groupMatches: [WINQMatch] { appState.matches.filter { $0.isGroup } }

    var body: some View {
        NavigationStack {
            ZStack {
                WK.paper.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack(alignment: .lastTextBaseline) {
                        Text("Inbox")
                            .font(WK.emph(32))
                            .foregroundColor(WK.ink)
                        Spacer()
                        Text("WINQ · \(mutualMatches.filter(\.isFresh).count)")
                            .font(WK.mono(11))
                            .foregroundColor(WK.ink2)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Tab pills
                    HStack(spacing: 8) {
                        ForEach(Array(tabs.enumerated()), id: \.0) { idx, tab in
                            Button(tab) { selectedTab = idx }
                                .buttonStyle(WKButtonStyle(
                                    fill: selectedTab == idx ? WK.ink : .clear,
                                    stroke: WK.ink,
                                    foreground: selectedTab == idx ? WK.paper : WK.ink,
                                    size: .sm
                                ))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)

                    WavyDivider()
                        .padding(.horizontal, 20)

                    // List
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            let items = selectedTab == 2 ? groupMatches : mutualMatches
                            ForEach(items) { match in
                                Button {
                                    if match.isGroup {
                                        showGroup = true
                                    } else {
                                        selectedMatch = match
                                    }
                                } label: {
                                    InboxRow(match: match)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationDestination(item: $selectedMatch) { match in
                MatchRevealView(match: match)
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showGroup) {
                GroupMatchView()
                    .environmentObject(appState)
            }
        }
    }
}

struct InboxRow: View {
    let match: WINQMatch

    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(match.isFresh ? WK.ink : WK.ink.opacity(0.55))
                        .frame(width: 52, height: 52)
                    EyeIcon(size: 30, stroke: WK.paper, filled: true)
                }

                if match.isFresh {
                    Circle()
                        .fill(WK.accent)
                        .frame(width: 13, height: 13)
                        .overlay(Circle().stroke(WK.paper, lineWidth: 2))
                        .offset(x: 2, y: -2)
                }
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(match.isGroup ? "Group · \(match.groupCount) clicks" : "someone WINQ'd you")
                    .font(WK.hand(14)).fontWeight(.bold)
                    .foregroundColor(WK.ink)
                Text("\(match.timeAgo) · \(match.location)")
                    .font(WK.hand(13))
                    .foregroundColor(WK.ink2)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(WK.ink2)
                .font(.system(size: 14))
        }
        .padding(12)
        .wkBox(fill: match.isFresh ? WK.accentSoft : WK.paper)
    }
}
