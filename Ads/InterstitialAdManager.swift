import Foundation
import Combine
import UIKit

struct AdConfig {
    static let bannerID = "demo-banner-yandex" // TODO: Replace with your Yandex Banner ID
    static let interstitialID = "demo-interstitial-yandex" // TODO: Replace with your Yandex Interstitial ID
}

#if canImport(YandexMobileAds)
import YandexMobileAds

final class InterstitialAdManager: NSObject, ObservableObject {

    @Published private(set) var isReady = false
    private var interstitialAd: InterstitialAd?
    private var adLoader: InterstitialAdLoader?

    private let adUnitID = AdConfig.interstitialID

    override init() {
        super.init()
        load()
    }

    func load() {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        self.adLoader = loader
        
        let configuration = AdRequestConfiguration(adUnitID: adUnitID)
        loader.loadAd(with: configuration)
    }

    func show() {
        guard let ad = interstitialAd,
              let vc = UIApplication.shared.topViewController()
        else { 
            load()
            return 
        }

        ad.delegate = self
        ad.show(from: vc)
        interstitialAd = nil
        isReady = false
    }
}

extension InterstitialAdManager: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        DispatchQueue.main.async {
            self.interstitialAd = interstitialAd
            self.isReady = true
        }
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        print("Yandex Interstitial failed to load: \(error.error.localizedDescription)")
        DispatchQueue.main.async {
            self.isReady = false
        }
    }
}

extension InterstitialAdManager: InterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: Error) {
        print("Yandex Interstitial failed to show: \(error.localizedDescription)")
        load()
    }

    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        load()
    }
}

#else
final class InterstitialAdManager: NSObject, ObservableObject {
    @Published private(set) var isReady = false
    override init() { super.init() }
    func load() {}
    func show() {}
}
#endif
