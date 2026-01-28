import Foundation

enum Persistence {
    enum Keys {
        static let settings = "user_settings_v1"
        static let session  = "quit_session_v1"
    }

    static func save<T: Codable>(_ value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save error:", error)
        }
    }

    static func load<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Load error:", error)
            return nil
        }
    }
}
