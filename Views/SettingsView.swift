import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var store: AppStore
    @StateObject private var interstitial = InterstitialAdManager()

    var body: some View {
        NavigationView {
            Form {
                Section("Kullanıcı Bilgileri") {
                    Stepper("Günde: \(store.settings.cigsPerDay) adet", value: $store.settings.cigsPerDay, in: 0...200)
                    Stepper("Pakette: \(store.settings.cigsPerPack) adet", value: $store.settings.cigsPerPack, in: 1...50)

                    HStack {
                        Text("Paket fiyatı (₺)")
                        Spacer()
                        TextField("0", value: $store.settings.packPrice, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 140)
                    }

                    Stepper("1 sigara süresi: \(store.settings.minutesPerCig) dk", value: $store.settings.minutesPerCig, in: 0...60)
                }

                Section("Bildirimler") {
                    Toggle("Bildirimleri Aç", isOn: $store.settings.notificationsEnabled)
                        .onChange(of: store.settings.notificationsEnabled) { _, newValue in
                            if newValue {
                                requestNotifications()
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }
                }

                Section("Sayaç") {
                    Button("Bırakma başlangıcını şimdiye çek") {
                        store.resetStartNow()
                    }

                    Button(role: .destructive) {
                        store.smokedAndReset()

                        // Ornek: her 3 resetten birinde interstitial
                        if store.session.smokedResetCount % 3 == 0 {
                            interstitial.show()
                        }
                    } label: {
                        Text("Sigara içtim (Sıfırla)")
                    }
                }

                Section {
                    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                        .frame(height: 50)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("Ayarlar")
        }
        .onAppear { interstitial.load() }
    }

    private func requestNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            scheduleDailyMotivation()
        }
    }

    private func scheduleDailyMotivation() {
        let content = UNMutableNotificationContent()
        content.title = "Sigarasızım"
        content.body = "Bugün de sigarasız bir gün için harika bir fırsat."
        content.sound = .default

        var date = DateComponents()
        date.hour = 10
        date.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_motivation_v1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
