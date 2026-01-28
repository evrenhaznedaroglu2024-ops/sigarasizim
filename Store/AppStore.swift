import Foundation
import Combine   // <-- SADECE BU

final class AppStore: ObservableObject {

    @Published var settings: UserSettings {
        didSet {
            Persistence.save(settings, key: Persistence.Keys.settings)
        }
    }

    @Published var session: QuitSession {
        didSet {
            Persistence.save(session, key: Persistence.Keys.session)
        }
    }

    init() {
        self.settings = Persistence.load(
            UserSettings.self,
            key: Persistence.Keys.settings
        ) ?? .defaultValue

        self.session = Persistence.load(
            QuitSession.self,
            key: Persistence.Keys.session
        ) ?? .defaultValue
    }

    func resetStartNow() {
        session.quitStartDate = Date()
    }

    func smokedAndReset() {
        session.quitStartDate = Date()
        session.smokedResetCount += 1
        session.lastResetDate = Date()
    }
}
