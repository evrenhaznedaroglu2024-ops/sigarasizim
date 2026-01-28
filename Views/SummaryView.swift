import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var store: AppStore
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let stats = StatsCalculator.compute(now: now, settings: store.settings, session: store.session)

        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Text("Sigarasız Geçen Süre")
                            .font(.headline)
                        Text(formatElapsed(stats.elapsedSeconds))
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .monospacedDigit()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .cornerRadius(16)

                    HStack(spacing: 12) {
                        StatCard(
                            title: "Kazanılan Para",
                            value: formatCurrency(stats.moneySaved),
                            systemImage: "turkishlirasign.circle.fill"
                        )
                        StatCard(
                            title: "Kazanılan Zaman",
                            value: formatTimeSaved(minutes: stats.timeSavedMinutes),
                            systemImage: "clock.fill"
                        )
                    }

                    StatCard(
                        title: "İçilmeyen Sigara",
                        value: "\(stats.notSmokedCount) adet",
                        systemImage: "nosign"
                    )

                    // AdMob Banner (TEST ID)
                    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 50)
                        .padding(.vertical, 8)
                }
                .padding()
            }
            .navigationTitle("Özet")
        }
        .onReceive(timer) { now = $0 }
    }

    private func formatElapsed(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let days = total / 86400
        let hours = (total % 86400) / 3600
        let minutes = (total % 3600) / 60
        let secs = total % 60
        if days > 0 { return "\(days) gün \(hours) sa \(minutes) dk \(secs) sn" }
        if hours > 0 { return "\(hours) sa \(minutes) dk \(secs) sn" }
        return "\(minutes) dk \(secs) sn"
    }

    private func formatCurrency(_ amount: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "TRY"
        f.maximumFractionDigits = 2
        return f.string(from: amount as NSNumber) ?? "₺0,00"
    }

    private func formatTimeSaved(minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        if h > 0 { return "\(h) saat \(m) dk" }
        return "\(m) dk"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: systemImage)
                Text(title).font(.subheadline).foregroundStyle(.secondary)
                Spacer()
            }
            Text(value)
                .font(.title2.bold())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .cornerRadius(16)
    }
}
