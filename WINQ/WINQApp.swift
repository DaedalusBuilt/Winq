import SwiftUI

@main
struct WINQApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var filters = WINQFilters()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.hasCompletedOnboarding {
                    ContentView()
                        .environmentObject(appState)
                        .environmentObject(filters)
                        .sheet(isPresented: $appState.showMatchReveal) {
                            if let match = appState.pendingMatch {
                                MatchRevealView(match: match)
                                    .environmentObject(appState)
                            }
                        }
                } else {
                    OnboardingContainerView()
                        .environmentObject(appState)
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
