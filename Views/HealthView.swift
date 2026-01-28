import SwiftUI
import Combine

struct HealthView: View {
    @EnvironmentObject var store: AppStore
    @State private var now = Date()
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    @State private var orientation = UIDevice.current.orientation

    var body: some View {
        let elapsed = max(0, now.timeIntervalSince(store.session.quitStartDate))
        let minutesElapsed = Int(elapsed / 60)
        let milestones = HealthTimelineProvider.getMilestones(language: store.settings.language)

        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header Status
                    VStack(spacing: 8) {
                        Text(Localization.shared.string("health_body_healing", for: store.settings.language))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(Localization.shared.string("health_smoke_free_duration", for: store.settings.language))\(formatElapsed(elapsed))")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)

                    // Timeline Cards
                    VStack(spacing: 16) {
                        ForEach(milestones) { milestone in
                            HealthCard(milestone: milestone, minutesElapsed: minutesElapsed, language: store.settings.language)
                        }
                    }
                    .padding(.horizontal)

                    // Ad View
                    BannerAdView(adUnitID: AdConfig.bannerID)
                        .frame(height: 50)
                        .padding(.vertical, 8)
                        
                    // Medical Disclaimer
                    MedicalDisclaimerView(language: store.settings.language)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .padding(.vertical)
            }
            .background(AppTheme.background.ignoresSafeArea())
            .navigationTitle(Localization.shared.string("health_title", for: store.settings.language))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onReceive(timer) { now = $0 }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
        .id(orientation)
    }

    private func formatElapsed(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let days = total / 86400
        let hours = (total % 86400) / 3600
        let minutes = (total % 3600) / 60
        if days > 0 { return "\(days) \(Localization.shared.string("unit_day", for: store.settings.language)) \(hours) \(Localization.shared.string("unit_hour", for: store.settings.language))" }
        if hours > 0 { return "\(hours) \(Localization.shared.string("unit_hour", for: store.settings.language)) \(minutes) \(Localization.shared.string("unit_min", for: store.settings.language))" }
        return "\(minutes) \(Localization.shared.string("unit_min", for: store.settings.language))"
    }
}

struct HealthCard: View {
    let milestone: HealthMilestone
    let minutesElapsed: Int
    let language: AppLanguage

    var body: some View {
        let progress = HealthTimelineProvider.progress(minutesElapsed: minutesElapsed, milestone: milestone)
        let isCompleted = progress >= 1.0
        
        HStack(spacing: 16) {
            // Circular Progress Icon
            ZStack {
                Circle()
                    .stroke(AppTheme.accent.opacity(0.15), lineWidth: 4)
                    .frame(width: 56, height: 56)
                
                Circle()
                    .trim(from: 0, to: isCompleted ? 1 : progress)
                    .stroke(
                        isCompleted ? Color.green : AppTheme.accent,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 56, height: 56)
                    .animation(.easeOut(duration: 1.0), value: progress)
                
                Image(systemName: isCompleted ? "checkmark" : milestone.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isCompleted ? .green : AppTheme.accent)
            }
            
            // Text Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(milestone.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)
                    Spacer()
                    if isCompleted {
                        Text(Localization.shared.string("health_completed", for: language))
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    } else {
                        Text("\(Int(progress * 100))%")
                            .font(.caption2)
                            .monospacedDigit()
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                
                Text(milestone.detail)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if !isCompleted {
                    Text(remainingTimeText(totalMinutes: milestone.minutesFromStart, elapsed: minutesElapsed))
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary.opacity(0.8))
                        .padding(.top, 2)
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
    
    private func remainingTimeText(totalMinutes: Int, elapsed: Int) -> String {
        let remaining = max(0, totalMinutes - elapsed)
        let days = remaining / (24 * 60)
        let hours = (remaining % (24 * 60)) / 60
        let minutes = remaining % 60
        
        let remainingStr = Localization.shared.string("health_remaining", for: language)
        
        if days > 0 { return "⏳ \(days) \(Localization.shared.string("unit_day", for: language)) \(remainingStr)" }
        if hours > 0 { return "⏳ \(hours) \(Localization.shared.string("unit_hour", for: language)) \(remainingStr)" }
        return "⏳ \(minutes) \(Localization.shared.string("unit_min", for: language)) \(remainingStr)"
    }
}

struct MedicalDisclaimerView: View {
    let language: AppLanguage
    
    var body: some View {
        VStack(spacing: 8) {
            Text(Localization.shared.string("medical_disclaimer", for: language))
                .font(.caption2)
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            if let url = URL(string: Localization.shared.string("medical_source_url", for: language)) {
                Link(destination: url) {
                    Text(Localization.shared.string("medical_source_title", for: language))
                        .font(.caption2)
                        .foregroundStyle(AppTheme.accent)
                        .underline()
                }
            }
        }
        .padding(12)
        .background(AppTheme.background)
        .cornerRadius(8)
    }
}
