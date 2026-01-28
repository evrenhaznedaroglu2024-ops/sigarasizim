import Foundation
import GoogleMobileAds
import AppTrackingTransparency

final class AdMobManager {
    static let shared = AdMobManager()
    private init() {}

    func start() {
        MobileAds.shared.start(completionHandler: nil)
    }
}
