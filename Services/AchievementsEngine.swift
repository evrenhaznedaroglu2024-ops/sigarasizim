import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let isUnlocked: Bool
}

enum AchievementsEngine {
    static func build(stats: Stats, language: AppLanguage) -> [Achievement] {
        let days = Int(stats.elapsedSeconds / 86400)

        // Time Targets with Localization Keys
        // Array of (DayCount, KeyPrefix)
        let timeTargets: [(Int, String)] = [
            (1, "ach_1_day"),
            (3, "ach_3_days"),
            (7, "ach_1_week"),
            (14, "ach_2_weeks"),
            (30, "ach_1_month"),
            (90, "ach_3_months"),
            (180, "ach_6_months"),
            (365, "ach_1_year")
        ]

        let moneyTargets = [100.0, 250.0, 500.0, 1000.0, 2500.0]
        let timeSavedTargetsHours: [(Int, String)] = [
            (6, "ach_6_hours"),
            (12, "ach_12_hours")
        ]

        var items: [Achievement] = []
        
        // Custom hours logic for 6/12 hours if needed or handled above
        // Let's stick to the previous simple logic but localized
        
        // Re-implementing based on original logic but with localization
        // Since I made keys like "ach_1_day", I should map them.
        
        // Hours
        if (stats.elapsedSeconds / 3600) >= 6 {
             items.append(.init(title: Localization.shared.string("ach_6_hours", for: language), detail: Localization.shared.string("ach_6_hours_detail", for: language), isUnlocked: true))
        } else {
             items.append(.init(title: Localization.shared.string("ach_6_hours", for: language), detail: Localization.shared.string("ach_6_hours_detail", for: language), isUnlocked: false))
        }
        
        if (stats.elapsedSeconds / 3600) >= 12 {
             items.append(.init(title: Localization.shared.string("ach_12_hours", for: language), detail: Localization.shared.string("ach_12_hours_detail", for: language), isUnlocked: true))
        } else {
             items.append(.init(title: Localization.shared.string("ach_12_hours", for: language), detail: Localization.shared.string("ach_12_hours_detail", for: language), isUnlocked: false))
        }

        for (d, keyPrefix) in timeTargets {
            items.append(.init(
                title: Localization.shared.string(keyPrefix, for: language),
                detail: Localization.shared.string(keyPrefix + "_detail", for: language),
                isUnlocked: days >= d
            ))
        }

        for m in moneyTargets {
            items.append(.init(
                title: Localization.shared.string("ach_money_saver", for: language),
                detail: Localization.shared.string("ach_money_saver_detail", for: language).replacingOccurrences(of: "500", with: "\(Int(m))"),
                isUnlocked: stats.moneySaved >= m
            ))
        }

        return items.sorted { ($0.isUnlocked ? 0 : 1) < ($1.isUnlocked ? 0 : 1) }
    }
}
