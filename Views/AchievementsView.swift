import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var store: AppStore

    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        let stats = StatsCalculator.compute(now: Date(), settings: store.settings, session: store.session)
        let achievements = AchievementsEngine.build(stats: stats, language: store.settings.language)

        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(achievements) { a in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: a.isUnlocked ? "medal.fill" : "lock.fill")
                                Spacer()
                            }
                            Text(a.title).font(.headline)
                            Text(a.detail).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial)
                        .cornerRadius(16)
                        .opacity(a.isUnlocked ? 1.0 : 0.65)
                    }
                }
                .padding()

                BannerAdView(adUnitID: AdConfig.bannerID)
                    .frame(height: 50)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .navigationTitle(Localization.shared.string("achievements_title", for: store.settings.language))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
        .id(orientation)
    }
}
