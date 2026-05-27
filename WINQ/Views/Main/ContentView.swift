import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ClickView()
                .tabItem {
                    Label("Click", systemImage: "eye")
                }
                .tag(AppState.Tab.click)

            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "tray")
                }
                .badge(appState.matches.filter { $0.isFresh }.count)
                .tag(AppState.Tab.inbox)

            WINQMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(AppState.Tab.map)

            ProfileView()
                .tabItem {
                    Label("Me", systemImage: "person.circle")
                }
                .tag(AppState.Tab.me)
        }
        .tint(WK.accent)
        .background(WK.paper)
    }
}
