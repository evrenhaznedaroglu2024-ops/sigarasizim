import SwiftUI

// MARK: - Design System (Local Definition)

struct AppTheme {
    static let primary = Color.blue
    static let accent = Color.indigo
    static let background = Color(uiColor: .systemGroupedBackground)
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(AppTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

// MARK: - Local Components

struct Card<Content: View>: View {
    let title: String?
    @ViewBuilder var content: Content

    init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
            }
            content
        }
        .cardStyle()
    }
}

struct MetricTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.textPrimary)
            }
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppTheme.background)
        )
    }
}

// MARK: - Embedded UI Components (moved to separate files)

struct SummaryView: View {
    @EnvironmentObject var store: AppStore
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header Area
                    VStack(spacing: 8) {
                        Text(Localization.shared.string("summary_journey", for: store.settings.language))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(Localization.shared.string("summary_how_long", for: store.settings.language))
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)

                    Card(Localization.shared.string("summary_card_today", for: store.settings.language)) {
                        VStack(spacing: 10) {
                            MetricTile(title: Localization.shared.string("summary_time_smoke_free", for: store.settings.language), value: smokeFreeText, icon: "clock")
                            MetricTile(title: Localization.shared.string("summary_cigs_not_smoked", for: store.settings.language), value: notSmokedText, icon: "lungs.fill")
                            MetricTile(title: Localization.shared.string("summary_money_saved", for: store.settings.language), value: moneyText, icon: "turkishlirasign.circle")
                            MetricTile(title: Localization.shared.string("summary_time_saved", for: store.settings.language), value: timeText, icon: "hourglass")
                        }
                    }

                    Card(Localization.shared.string("summary_stats", for: store.settings.language)) {
                        VStack(alignment: .leading, spacing: 16) {
                            statRow(title: Localization.shared.string("summary_daily_consumption", for: store.settings.language), value: "\(store.settings.cigsPerDay) \(Localization.shared.string("unit_count", for: store.settings.language))", icon: "flame.fill")
                            statRow(title: Localization.shared.string("summary_pack_price", for: store.settings.language), value: formatTRY(Double(store.settings.packPrice)), icon: "tag.fill")
                            statRow(title: Localization.shared.string("summary_in_pack", for: store.settings.language), value: "\(store.settings.cigsPerPack) \(Localization.shared.string("unit_count", for: store.settings.language))", icon: "square.stack.3d.up.fill")
                            statRow(title: Localization.shared.string("summary_time_per_cig", for: store.settings.language), value: "\(store.settings.minutesPerCig) \(Localization.shared.string("unit_min", for: store.settings.language))", icon: "timer")
                        }
                    }

                    Card {
                        BannerAdView(adUnitID: AdConfig.bannerID)
                            .frame(height: 60)
                    }
                }
                .padding(16)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(Localization.shared.string("summary_title", for: store.settings.language))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if #available(iOS 17.0, *) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .tint(AppTheme.textPrimary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                if #available(iOS 17.0, *) {
                    SettingsView()
                }
            }
        }
    }
    
    // Helper for stats
    private func statRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.accent)
                .frame(width: 24)
            Text(title)
                .foregroundColor(AppTheme.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textPrimary)
        }
    }

    // MARK: - Calculations

    private var elapsedSeconds: TimeInterval {
        max(0, Date().timeIntervalSince(store.session.quitStartDate))
    }

    private var elapsedDays: Double {
        elapsedSeconds / 86400.0
    }

    private var notSmokedCigs: Double {
        max(0, Double(store.settings.cigsPerDay)) * elapsedDays
    }

    private var costPerCig: Double {
        let packPrice = Double(store.settings.packPrice)
        let perPack = max(1, store.settings.cigsPerPack)
        return packPrice / Double(perPack)
    }

    private var moneySaved: Double {
        notSmokedCigs * costPerCig
    }

    private var minutesSaved: Double {
        notSmokedCigs * Double(store.settings.minutesPerCig)
    }

    private var smokeFreeText: String {
        formatDuration(seconds: elapsedSeconds)
    }

    private var moneyText: String {
        formatTRY(moneySaved)
    }

    private var timeText: String {
        if minutesSaved < 60 {
            return "\(Int(minutesSaved.rounded())) \(Localization.shared.string("unit_min", for: store.settings.language))"
        }
        let hours = minutesSaved / 60.0
        if hours < 48 {
            return String(format: "%.1f \(Localization.shared.string("unit_hour", for: store.settings.language))", hours)
        }
        let days = hours / 24.0
        return String(format: "%.1f \(Localization.shared.string("unit_day", for: store.settings.language))", days)
    }
    
    private var notSmokedText: String {
        return String(format: "%.0f \(Localization.shared.string("unit_count", for: store.settings.language))", notSmokedCigs)
    }

    // MARK: - Formatting

    private func formatTRY(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "₺"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        return f.string(from: NSNumber(value: value)) ?? "₺0"
    }

    private func formatDuration(seconds: TimeInterval) -> String {
        let s = Int(seconds.rounded(.down))
        let days = s / 86400
        let hours = (s % 86400) / 3600
        let mins = (s % 3600) / 60

        if days > 0 {
            return "\(days) \(Localization.shared.string("unit_day", for: store.settings.language)) \(hours) \(Localization.shared.string("unit_hour", for: store.settings.language))"
        } else if hours > 0 {
            return "\(hours) \(Localization.shared.string("unit_hour", for: store.settings.language)) \(mins) \(Localization.shared.string("unit_min", for: store.settings.language))"
        } else {
            return "\(mins) \(Localization.shared.string("unit_min", for: store.settings.language))"
        }
    }
}
