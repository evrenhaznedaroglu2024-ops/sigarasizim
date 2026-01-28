import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        let stats = StatsCalculator.compute(now: Date(), settings: store.settings, session: store.session)
        let achievements = AchievementsEngine.build(stats: stats)

        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
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

                BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                    .frame(height: 50)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .navigationTitle("Kazanımlar")
        }
    }
}
