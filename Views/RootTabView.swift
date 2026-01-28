import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            SummaryView()
                .tabItem { Label(Localization.shared.string("tab_summary", for: store.settings.language), systemImage: "chart.bar.fill") }

            HealthView()
                .tabItem { Label(Localization.shared.string("tab_health", for: store.settings.language), systemImage: "heart.fill") }

            AchievementsView()
                .tabItem { Label(Localization.shared.string("tab_achievements", for: store.settings.language), systemImage: "medal.fill") }

            BreathTestView()
                .tabItem { Label(Localization.shared.string("tab_breath", for: store.settings.language), systemImage: "lungs.fill") }

            if #available(iOS 17.0, *) {
                SettingsView()
                    .tabItem { Label(Localization.shared.string("tab_settings", for: store.settings.language), systemImage: "gearshape.fill") }
            } else {
                // Fallback
            }
        }
    }
}
