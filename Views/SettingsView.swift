import SwiftUI
import UserNotifications

@available(iOS 17.0, *)
@available(iOS 17.0, *)
struct SettingsView: View {
    @EnvironmentObject var store: AppStore
    @StateObject private var interstitial = InterstitialAdManager()
    @State private var showSaveConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Language Selection (NEW)
                    Card(Localization.shared.string("settings_language", for: store.settings.language)) {
                        Picker("", selection: $store.settings.language) {
                            ForEach(AppLanguage.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 4)
                    }

                    // User Info Section
                    Card(Localization.shared.string("settings_user_info", for: store.settings.language)) {
                        VStack(spacing: 16) {
                            customStepper(
                                title: Localization.shared.string("settings_daily", for: store.settings.language),
                                value: $store.settings.cigsPerDay,
                                range: 0...200,
                                suffix: Localization.shared.string("unit_count", for: store.settings.language)
                            )
                            
                            Divider().opacity(0.3)
                            
                            customStepper(
                                title: Localization.shared.string("settings_in_pack", for: store.settings.language),
                                value: $store.settings.cigsPerPack,
                                range: 1...50,
                                suffix: Localization.shared.string("unit_count", for: store.settings.language)
                            )
                            
                            Divider().opacity(0.3)
                            
                            HStack {
                                Text(Localization.shared.string("settings_pack_price", for: store.settings.language))
                                    .foregroundStyle(AppTheme.textSecondary)
                                Spacer()
                                HStack(spacing: 4) {
                                    Text("₺")
                                        .foregroundStyle(AppTheme.textSecondary)
                                    TextField("0", value: $store.settings.packPrice, format: .number)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 80)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(AppTheme.background)
                                        .cornerRadius(8)
                                }
                            }
                            
                            Divider().opacity(0.3)
                            
                            customStepper(
                                title: Localization.shared.string("settings_time_per_cig", for: store.settings.language),
                                value: $store.settings.minutesPerCig,
                                range: 0...60,
                                suffix: Localization.shared.string("unit_min", for: store.settings.language)
                            )
                        }
                    }

                    // Notifications Section
                    Card(Localization.shared.string("settings_notifications", for: store.settings.language)) {
                        Toggle(isOn: $store.settings.notificationsEnabled) {
                            Text(Localization.shared.string("settings_daily_motivation", for: store.settings.language))
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                        .tint(AppTheme.accent)
                        .onChange(of: store.settings.notificationsEnabled) { _, newValue in
                             if newValue {
                                 requestNotifications()
                             } else {
                                 UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                             }
                        }
                    }

                    // Reset / Actions
                    Card(Localization.shared.string("settings_counter_management", for: store.settings.language)) {
                        VStack(spacing: 12) {
                            DatePicker(Localization.shared.string("settings_quit_date", for: store.settings.language), selection: $store.session.quitStartDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .foregroundStyle(AppTheme.textSecondary)
                            
                            Divider().opacity(0.3)
                            
                             Button(role: .destructive) {
                                store.smokedAndReset()
                                if store.session.smokedResetCount % 3 == 0 {
                                    interstitial.show()
                                }
                            } label: {
                                Text(Localization.shared.string("settings_smoked_reset", for: store.settings.language))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    // Save Button
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        showSaveConfirmation = true
                    } label: {
                        Text(Localization.shared.string("settings_save", for: store.settings.language))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.accent)
                            .cornerRadius(16)
                            .shadow(color: AppTheme.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 4)

                    // Ad
                    Card {
                        BannerAdView(adUnitID: AdConfig.bannerID)
                            .frame(height: 50)
                    }
                }
                .padding(16)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(Localization.shared.string("settings_title", for: store.settings.language))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { interstitial.load() }
        .alert(Localization.shared.string("settings_saved_alert_title", for: store.settings.language), isPresented: $showSaveConfirmation) {
            Button(Localization.shared.string("settings_ok", for: store.settings.language), role: .cancel) { }
        } message: {
            Text(Localization.shared.string("settings_saved_alert_msg", for: store.settings.language))
        }
    }

    // Custom Compact Stepper
    private func customStepper(title: String, value: Binding<Int>, range: ClosedRange<Int>, suffix: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
            Spacer()
            HStack(spacing: 0) {
                Button {
                    if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 }
                } label: {
                    Image(systemName: "minus")
                        .font(.caption)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.background)
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                Text("\(value.wrappedValue) \(suffix)")
                    .font(.footnote.monospacedDigit())
                    .frame(minWidth: 50)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppTheme.textPrimary)
                
                Button {
                    if value.wrappedValue < range.upperBound { value.wrappedValue += 1 }
                } label: {
                    Image(systemName: "plus")
                        .font(.caption)
                        .frame(width: 28, height: 28)
                        .background(AppTheme.background)
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
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
