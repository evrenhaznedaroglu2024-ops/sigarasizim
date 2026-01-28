import SwiftUI

struct HealthView: View {
    @EnvironmentObject var store: AppStore
    @State private var now = Date()
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        let elapsed = max(0, now.timeIntervalSince(store.session.quitStartDate))
        let minutesElapsed = Int(elapsed / 60)

        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bugün").font(.headline)
                        Text("Sigarasız geçen süre: \(formatElapsed(elapsed))")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Sağlık Zaman Çizelgesi") {
                    ForEach(HealthTimelineProvider.milestones) { m in
                        let done = minutesElapsed >= m.minutesFromStart
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(m.title).font(.headline)
                                Spacer()
                                Image(systemName: done ? "checkmark.seal.fill" : "hourglass")
                                    .foregroundStyle(done ? .green : .secondary)
                            }
                            Text(m.detail).foregroundStyle(.secondary)
                            if !done {
                                ProgressView(value: HealthTimelineProvider.progress(minutesElapsed: minutesElapsed, milestone: m))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }

                Section {
                    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 50)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("Sağlık")
        }
        .onReceive(timer) { now = $0 }
    }

    private func formatElapsed(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let days = total / 86400
        let hours = (total % 86400) / 3600
        let minutes = (total % 3600) / 60
        if days > 0 { return "\(days) gün \(hours) saat \(minutes) dk" }
        if hours > 0 { return "\(hours) saat \(minutes) dk" }
        return "\(minutes) dk"
    }
}
