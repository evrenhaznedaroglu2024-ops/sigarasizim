import Foundation

struct Stats {
    let elapsedSeconds: TimeInterval
    let notSmokedCount: Int
    let moneySaved: Double
    let timeSavedMinutes: Int
}

enum StatsCalculator {

    /// MVP: gun bazli tahmini icilmeyen sigara
    static func compute(now: Date, settings: UserSettings, session: QuitSession) -> Stats {
        let elapsed = max(0, now.timeIntervalSince(session.quitStartDate))
        let days = elapsed / 86400.0
        let notSmoked = Int((days * Double(max(0, settings.cigsPerDay))).rounded(.down))

        let costPerCig = safeCostPerCig(settings: settings)
        let money = Double(notSmoked) * costPerCig
        let timeSaved = notSmoked * max(0, settings.minutesPerCig)

        return Stats(
            elapsedSeconds: elapsed,
            notSmokedCount: max(0, notSmoked),
            moneySaved: max(0, money),
            timeSavedMinutes: max(0, timeSaved)
        )
    }

    static func safeCostPerCig(settings: UserSettings) -> Double {
        guard settings.cigsPerPack > 0 else { return 0 }
        return settings.packPrice / Double(settings.cigsPerPack)
    }
}
