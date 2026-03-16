import Foundation
#if canImport(YandexMobileAds)
import YandexMobileAds
#endif

final class YandexAdsManager {
    static let shared = YandexAdsManager()
    private init() {}

    func start() {
        #if canImport(YandexMobileAds)
        MobileAds.initializeSDK()
        #endif
    }
}
