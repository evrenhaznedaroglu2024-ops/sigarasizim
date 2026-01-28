import Foundation

struct QuitSession: Codable, Equatable {
    var quitStartDate: Date
    var smokedResetCount: Int
    var lastResetDate: Date?

    static let defaultValue = QuitSession(
        quitStartDate: Date(),
        smokedResetCount: 0,
        lastResetDate: nil
    )
}
