import Foundation

// MARK: - App Mode
enum WINQMode: String, CaseIterable {
    case winq = "WINQ"
    case finq = "FINQ"
    case binq = "BINQ"

    var label: String {
        switch self {
        case .winq: return "Romantic"
        case .finq: return "Friendship"
        case .binq: return "Business"
        }
    }
    var emoji: String {
        switch self {
        case .winq: return "❤️"
        case .finq: return "🤝"
        case .binq: return "💼"
        }
    }
}

// MARK: - A WINQ match
struct WINQMatch: Identifiable {
    let id = UUID()
    var name: String
    var age: Int
    var location: String
    var distance: String
    var timestamp: Date
    var bio: String
    var tags: [String]
    var isFresh: Bool
    var isGroup: Bool = false
    var groupCount: Int = 0

    var timeAgo: String {
        let diff = Date().timeIntervalSince(timestamp)
        if diff < 3600 { return "\(Int(diff / 60)) min ago" }
        if diff < 86400 { return "\(Int(diff / 3600)) hr ago" }
        return "Yesterday"
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentMode: WINQMode = .winq
    @Published var clicksRemainingThisWeek: Int = 3
    @Published var totalWINQsGlobal: Int = 48261
    @Published var nearbyCount: Int = 12
    @Published var selectedTab: Tab = .click

    @Published var pendingMatch: WINQMatch? = nil
    @Published var showMatchReveal: Bool = false

    @Published var matches: [WINQMatch] = WINQMatch.sampleData

    enum Tab { case click, inbox, map, me }

    func simulateWINQ() {
        guard clicksRemainingThisWeek > 0 else { return }
        clicksRemainingThisWeek -= 1
        totalWINQsGlobal += 1

        // 40% chance of a mutual WINQ
        if Bool.random() || true { // Always demo a match
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.pendingMatch = WINQMatch.sampleData.first
                self.showMatchReveal = true
            }
        }
    }
}

// MARK: - Sample data
extension WINQMatch {
    static let sampleData: [WINQMatch] = [
        WINQMatch(name: "Sam", age: 26, location: "Café Grumpy · Bedford", distance: "0.05 mi",
                  timestamp: Date().addingTimeInterval(-120), bio: "Reads Murakami on the subway.",
                  tags: ["☕ coffee", "📚 books", "🎷 jazz"], isFresh: true),
        WINQMatch(name: "Jordan", age: 29, location: "L train · Lorimer", distance: "0.3 mi",
                  timestamp: Date().addingTimeInterval(-3600), bio: "Film photographer.",
                  tags: ["📷 film", "🚶 walking", "🌆 city"], isFresh: true),
        WINQMatch(name: "Riley", age: 24, location: "McCarren Park", distance: "0.8 mi",
                  timestamp: Date().addingTimeInterval(-86400), bio: "Runner. Coffee enthusiast.",
                  tags: ["🏃 runs", "☕ coffee"], isFresh: false),
        WINQMatch(name: "Alex", age: 31, location: "Library on Smith", distance: "1.2 mi",
                  timestamp: Date().addingTimeInterval(-90000), bio: "Architect by day.",
                  tags: ["🏛 design", "📖 reading"], isFresh: false),
        WINQMatch(name: "Group · Concert", age: 0, location: "Brooklyn Steel",
                  distance: "0.1 mi", timestamp: Date().addingTimeInterval(-3000),
                  bio: "14 clicks in the same moment.", tags: [],
                  isFresh: true, isGroup: true, groupCount: 14),
    ]
}

// MARK: - Filter model
struct WINQFilters: ObservableObject {
    @Published var sexualPreference: String = "women"
    @Published var ageMin: Double = 22
    @Published var ageMax: Double = 35
    @Published var maxDistance: Double = 2.0
    @Published var heightMin: String = "5'5\""
    @Published var religion: String = "any"
    @Published var substances: String = "non-smoker"
    @Published var athleticism: String = "active"

    // Deal breaker = filter out entirely; soft = send to daily clicks
    enum FilterStrength: String, CaseIterable {
        case dealBreaker = "Deal Breaker"
        case soft = "Don't Rule Out"
        case off = "—"
    }
    @Published var strengthMap: [String: FilterStrength] = [
        "sexualPreference": .dealBreaker,
        "age": .dealBreaker,
        "distance": .dealBreaker,
        "height": .soft,
        "religion": .soft,
        "substances": .soft,
        "athleticism": .soft,
    ]
}

// MARK: - Map pin
struct WINQPin: Identifiable {
    let id = UUID()
    var count: Int
    var latitude: Double
    var longitude: Double
}

// MARK: - Chatbot message
struct ChatMessage: Identifiable {
    let id = UUID()
    var isBot: Bool
    var text: String
}
