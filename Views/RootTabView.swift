import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            SummaryView()
                .tabItem { Label("Özet", systemImage: "chart.bar.fill") }

            HealthView()
                .tabItem { Label("Sağlık", systemImage: "heart.fill") }

            AchievementsView()
                .tabItem { Label("Kazanımlar", systemImage: "medal.fill") }

            BreathTestView()
                .tabItem { Label("Test", systemImage: "lungs.fill") }

            SettingsView()
                .tabItem { Label("Ayarlar", systemImage: "gearshape.fill") }
        }
    }
}
