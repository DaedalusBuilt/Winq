import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showFilters = false
    @State private var showChances = false
    @State private var showSettings = false

    let tags = ["☕ coffee", "🚶 walking", "📷 film", "🎷 jazz", "🏃 runs"]
    let sharedInfo = ["City · Brooklyn", "Age · 28", "@alex_ig (IG)", "Bio"]

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .bottom) {
                    WK.paper.ignoresSafeArea()

                    VStack(spacing: 0) {
                        // "In the wild" full-bleed background photo
                        ZStack(alignment: .bottomLeading) {
                            PhotoSlot(
                                label: "\"in the wild\"\nfull-body photo\noutdoors · candid",
                                height: 300, radius: 0
                            )

                            // Profile photo overlap
                            ZStack {
                                Circle()
                                    .fill(WK.ink)
                                    .frame(width: 90, height: 90)
                                EyeIcon(size: 54, stroke: WK.paper, filled: true)
                            }
                            .overlay(Circle().stroke(WK.paper, lineWidth: 3))
                            .offset(x: 18, y: 45)
                        }

                        // Content below photo
                        VStack(alignment: .leading, spacing: 12) {
                            // Name row
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Alex, 28")
                                        .font(WK.emph(32))
                                        .foregroundColor(WK.ink)
                                    Text("Brooklyn · 0.3 mi")
                                        .font(WK.hand(14))
                                        .foregroundColor(WK.ink2)
                                }
                                Spacer()
                                Button("edit") {}
                                    .buttonStyle(WKButtonStyle(size: .sm))
                            }
                            .padding(.top, 50) // room for overlapping photo

                            WavyDivider()

                            // Bio
                            Text("\"I read on the subway. I drink my coffee black. Don't be weird about it.\"")
                                .font(WK.hand(15))
                                .foregroundColor(WK.ink2)
                                .lineSpacing(4)

                            // Tags
                            FlowLayout(spacing: 6) {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(WK.hand(12))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .wkBox(fill: WK.paperDim, radius: 999)
                                }
                            }

                            // Social links
                            HStack(spacing: 8) {
                                Button("🔗 IG") {}
                                    .buttonStyle(WKButtonStyle(fill: WK.paper, size: .sm))
                                Button("💼 LinkedIn") {}
                                    .buttonStyle(WKButtonStyle(fill: WK.paper, size: .sm))
                            }

                            WavyDivider()

                            // Shared info section
                            VStack(alignment: .leading, spacing: 0) {
                                Text("SHOWING ON MATCH")
                                    .font(WK.mono(10))
                                    .foregroundColor(WK.ink3)
                                    .padding(.bottom, 6)

                                ForEach(sharedInfo, id: \.self) { row in
                                    HStack {
                                        Text(row)
                                            .font(WK.hand(14))
                                            .foregroundColor(WK.ink)
                                        Spacer()
                                        Text("ON ●")
                                            .font(WK.mono(10))
                                            .foregroundColor(WK.ink2)
                                    }
                                    .padding(.vertical, 8)
                                    Divider().overlay(WK.ink3)
                                        .opacity(0.4)
                                }
                            }

                            WavyDivider()

                            // Feature buttons
                            VStack(spacing: 10) {
                                Button {
                                    showFilters = true
                                } label: {
                                    HStack {
                                        Image(systemName: "slider.horizontal.3")
                                        Text("My Filters & Deal-breakers")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(WK.hand(15))
                                    .foregroundColor(WK.ink)
                                }
                                .padding(12)
                                .wkBox(fill: WK.paperDim)

                                Button {
                                    showChances = true
                                } label: {
                                    HStack {
                                        Image(systemName: "clock.arrow.circlepath")
                                        Text("What Are the Chances?")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(WK.hand(15))
                                    .foregroundColor(WK.ink)
                                }
                                .padding(12)
                                .wkBox(fill: WK.paperDim)
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(WK.paper)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(WK.ink)
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView()
            }
            .sheet(isPresented: $showChances) {
                ChancesView()
            }
        }
    }
}

// MARK: - Simple flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, maxY: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > width && x > 0 {
                x = 0; y += rowH + spacing; rowH = 0
            }
            rowH = max(rowH, s.height)
            x += s.width + spacing
            maxY = y + rowH
        }
        return CGSize(width: width, height: maxY)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowH: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX; y += rowH + spacing; rowH = 0
            }
            v.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            rowH = max(rowH, s.height)
            x += s.width + spacing
        }
    }
}
