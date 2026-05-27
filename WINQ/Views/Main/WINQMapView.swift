import SwiftUI
import MapKit

struct WINQMapView: View {
    @State private var showStats = true
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    let pins: [WINQPin] = [
        WINQPin(count: 5, latitude: 40.7193, longitude: -73.9549),
        WINQPin(count: 12, latitude: 40.7282, longitude: -74.0776),
        WINQPin(count: 3, latitude: 40.7061, longitude: -74.0087),
        WINQPin(count: 7, latitude: 40.6892, longitude: -73.9826),
        WINQPin(count: 2, latitude: 40.7480, longitude: -73.9850),
        WINQPin(count: 4, latitude: 40.7614, longitude: -73.9776),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Map
            Map(coordinateRegion: $mapRegion, annotationItems: pins) { pin in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: pin.latitude, longitude: pin.longitude)) {
                    WINQPinView(count: pin.count)
                }
            }
            .ignoresSafeArea()

            // Top bar
            .overlay(alignment: .top) {
                HStack {
                    Text("WINQ MAP")
                        .font(WK.hand(14))
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(WK.paper)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(WK.ink, lineWidth: 1.5))

                    Spacer()

                    Button("filter ▾") {}
                        .font(WK.hand(13))
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(WK.paper)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(WK.ink, lineWidth: 1.5))
                        .foregroundColor(WK.ink)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // Stats panel
            if showStats {
                StatsPanel()
                    .padding(16)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct WINQPinView: View {
    let count: Int
    var body: some View {
        ZStack {
            Circle()
                .fill(WK.accent.opacity(0.18))
                .frame(width: CGFloat(count) * 3 + 24, height: CGFloat(count) * 3 + 24)
            Circle()
                .fill(WK.accent)
                .frame(width: 20, height: 20)
                .overlay(Circle().stroke(WK.paper, lineWidth: 1.5))
            Text("\(count)")
                .font(WK.mono(9))
                .foregroundColor(WK.paper)
                .fontWeight(.bold)
        }
    }
}

struct StatsPanel: View {
    @State private var showGlobal = false
    let cities = [("New York", 4280), ("Los Angeles", 2104), ("London", 1812),
                  ("Berlin", 1199), ("Tokyo", 1086)]

    var body: some View {
        VStack(spacing: 0) {
            if showGlobal {
                // Global view
                VStack(spacing: 6) {
                    Text("ALL CONNECTIONS · EVER")
                        .font(WK.mono(9))
                        .foregroundColor(WK.ink3)
                    Text("48,261")
                        .font(WK.emph(48)).fontWeight(.bold)
                        .foregroundColor(WK.accent)
                    Text("and counting · +12 right now")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink2)
                    WavyDivider().padding(.vertical, 4)
                    ForEach(cities, id: \.0) { city, count in
                        HStack {
                            Text("· \(city)")
                                .font(WK.hand(14))
                                .foregroundColor(WK.ink)
                            Spacer()
                            Text("\(count)")
                                .font(WK.mono(12))
                                .foregroundColor(WK.accent)
                        }
                        .padding(.vertical, 3)
                    }
                }
                .padding(14)
                .wkCard()
            } else {
                // Local view
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("BROOKLYN · TODAY")
                            .font(WK.mono(9))
                            .foregroundColor(WK.ink3)
                        Text("1,284 winqs")
                            .font(WK.emph(26))
                            .foregroundColor(WK.accent)
                        Text("· 33 in the last hour ·")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink2)
                    }
                    Spacer()
                    Button { withAnimation { showGlobal = true } } label: {
                        Text("global →")
                            .font(WK.hand(13))
                            .foregroundColor(WK.ink)
                    }
                    .padding(10)
                    .wkBox(radius: 10)
                }
                .padding(14)
                .wkCard()
            }

            if showGlobal {
                Button { withAnimation { showGlobal = false } } label: {
                    Text("· see map view")
                        .font(WK.hand(13))
                        .foregroundColor(WK.ink)
                }
                .buttonStyle(WKButtonStyle(fill: WK.paper, fullWidth: true))
                .padding(.top, 8)
            }
        }
    }
}
