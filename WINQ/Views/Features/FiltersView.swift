import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var filters = WINQFilters()

    struct FilterRow: Identifiable {
        let id = UUID()
        var key: String
        var label: String
        var value: String
    }

    let rows: [FilterRow] = [
        .init(key: "sexualPreference", label: "Sexual preference", value: "women"),
        .init(key: "age",              label: "Age",               value: "24 — 32"),
        .init(key: "height",           label: "Height",            value: "5'6\" +"),
        .init(key: "distance",         label: "Distance",          value: "< 2 mi"),
        .init(key: "religion",         label: "Religion",          value: "any"),
        .init(key: "substances",       label: "Substances",        value: "non-smoker"),
        .init(key: "athleticism",      label: "Athleticism",       value: "active"),
        .init(key: "hobbies",          label: "Hobbies",           value: "reading · music · art"),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                WK.paper.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Filters")
                                .font(WK.emph(28))
                                .foregroundColor(WK.ink)
                            Text("What gets through? What goes to daily clicks?")
                                .font(WK.hand(13))
                                .foregroundColor(WK.ink2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        // Legend
                        HStack(spacing: 16) {
                            legendPill("DEAL BREAKER", color: WK.ink, text: WK.paper)
                            legendPill("DON'T RULE OUT", color: WK.accentSoft, text: WK.accent)
                            legendPill("—", color: WK.paperDim, text: WK.ink3)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        WavyDivider()
                            .padding(.horizontal, 20)
                            .padding(.top, 12)

                        // Filter rows
                        VStack(spacing: 0) {
                            ForEach(rows) { row in
                                FilterRowView(
                                    label: row.label,
                                    value: row.value,
                                    strength: filters.strengthMap[row.key] ?? .off
                                ) { newStrength in
                                    filters.strengthMap[row.key] = newStrength
                                }
                                Divider()
                                    .overlay(WK.ink3.opacity(0.3))
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 8)

                        // Deal-breaker explainer
                        HStack(alignment: .top, spacing: 10) {
                            Text("💡")
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Deal Breaker")
                                    .font(WK.hand(13)).fontWeight(.bold)
                                    .foregroundColor(WK.ink)
                                Text("Clicks that don't pass this filter are dropped entirely — the person never appears.")
                                    .font(WK.hand(13))
                                    .foregroundColor(WK.ink2)
                                    .lineSpacing(3)
                                Text("Don't Rule Out")
                                    .font(WK.hand(13)).fontWeight(.bold)
                                    .foregroundColor(WK.ink)
                                    .padding(.top, 4)
                                Text("Click goes to your "Daily Clicks" secondary list — still visible, not prioritized.")
                                    .font(WK.hand(13))
                                    .foregroundColor(WK.ink2)
                                    .lineSpacing(3)
                            }
                        }
                        .padding(14)
                        .wkBox(fill: WK.accentSoft, radius: 12)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                        Spacer().frame(height: 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(WK.hand(15))
                        .foregroundColor(WK.accent)
                }
            }
        }
    }

    func legendPill(_ label: String, color: Color, text: Color) -> some View {
        Text(label)
            .font(WK.mono(9))
            .foregroundColor(text)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

struct FilterRowView: View {
    var label: String
    var value: String
    var strength: WINQFilters.FilterStrength
    var onChange: (WINQFilters.FilterStrength) -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(WK.hand(14))
                    .foregroundColor(WK.ink)
                Text(value)
                    .font(WK.mono(11))
                    .foregroundColor(WK.ink3)
            }

            Spacer()

            // Strength toggle
            Menu {
                ForEach(WINQFilters.FilterStrength.allCases, id: \.self) { s in
                    Button(s.rawValue) { onChange(s) }
                }
            } label: {
                strengthBadge(strength)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    func strengthBadge(_ s: WINQFilters.FilterStrength) -> some View {
        switch s {
        case .dealBreaker:
            Text("DEAL BREAKER")
                .font(WK.mono(9))
                .foregroundColor(WK.paper)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(WK.ink)
                .clipShape(Capsule())
        case .soft:
            Text("DON'T RULE OUT")
                .font(WK.mono(9))
                .foregroundColor(WK.accent)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(WK.accentSoft)
                .clipShape(Capsule())
        case .off:
            Text("—")
                .font(WK.mono(10))
                .foregroundColor(WK.ink3)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(WK.paperDim)
                .clipShape(Capsule())
        }
    }
}
