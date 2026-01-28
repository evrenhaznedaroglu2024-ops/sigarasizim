import Foundation

struct HealthMilestone: Identifiable {
    let id = UUID()
    let minutesFromStart: Int
    let title: String
    let detail: String
    let icon: String // SF Symbol name
}

enum HealthTimelineProvider {
    static func getMilestones(language: AppLanguage) -> [HealthMilestone] {
        return [
            .init(minutesFromStart: 20,
                  title: Localization.shared.string("health_pulse_title", for: language),
                  detail: Localization.shared.string("health_pulse_detail", for: language),
                  icon: "heart.fill"),
            
            .init(minutesFromStart: 8 * 60,
                  title: Localization.shared.string("health_oxygen_title", for: language),
                  detail: Localization.shared.string("health_oxygen_detail", for: language),
                  icon: "lungs.fill"),
            
            .init(minutesFromStart: 24 * 60,
                  title: Localization.shared.string("health_heart_attack_title", for: language),
                  detail: Localization.shared.string("health_heart_attack_detail", for: language),
                  icon: "bolt.heart.fill"),
            
            .init(minutesFromStart: 48 * 60,
                  title: Localization.shared.string("health_taste_smell_title", for: language),
                  detail: Localization.shared.string("health_taste_smell_detail", for: language),
                  icon: "nose.fill"),
            
            .init(minutesFromStart: 72 * 60,
                  title: Localization.shared.string("health_energy_title", for: language),
                  detail: Localization.shared.string("health_energy_detail", for: language),
                  icon: "bolt.fill"),
            
            .init(minutesFromStart: 2 * 7 * 24 * 60,
                  title: Localization.shared.string("health_circulation_title", for: language),
                  detail: Localization.shared.string("health_circulation_detail", for: language),
                  icon: "figure.walk"),
            
            .init(minutesFromStart: 9 * 30 * 24 * 60,
                  title: Localization.shared.string("health_lung_clean_title", for: language),
                  detail: Localization.shared.string("health_lung_clean_detail", for: language),
                  icon: "allergens.fill"),
            
            .init(minutesFromStart: 365 * 24 * 60,
                  title: Localization.shared.string("health_heart_health_title", for: language),
                  detail: Localization.shared.string("health_heart_health_detail", for: language),
                  icon: "heart.circle.fill"),
            
            .init(minutesFromStart: 5 * 365 * 24 * 60,
                  title: Localization.shared.string("health_stroke_title", for: language),
                  detail: Localization.shared.string("health_stroke_detail", for: language),
                  icon: "brain.head.profile"),
            
            .init(minutesFromStart: 10 * 365 * 24 * 60,
                  title: Localization.shared.string("health_cancer_title", for: language),
                  detail: Localization.shared.string("health_cancer_detail", for: language),
                  icon: "staroflife.fill")
        ]
    }

    static func progress(minutesElapsed: Int, milestone: HealthMilestone) -> Double {
        if minutesElapsed >= milestone.minutesFromStart { return 1.0 }
        return Double(minutesElapsed) / Double(max(1, milestone.minutesFromStart))
    }
}
