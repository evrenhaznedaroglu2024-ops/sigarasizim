import Foundation
import Combine
import UIKit

struct AdConfig {
    static let bannerID = "ca-app-pub-3280740911723004/7320658212"
    static let interstitialID = "ca-app-pub-3280740911723004/6007576547"
}

#if canImport(GoogleMobileAds)
import GoogleMobileAds

final class InterstitialAdManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published private(set) var isReady = false
    private var interstitial: GADInterstitialAd?

    private let adUnitID = AdConfig.interstitialID

    override init() {
        super.init()
        load()
    }

    func load() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID,
                               request: request,
                               completionHandler: { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                DispatchQueue.main.async { self.isReady = false }
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            DispatchQueue.main.async { self.isReady = true }
        })
    }

    func show() {
        guard let ad = interstitial,
              let vc = UIApplication.shared.topViewController()
        else {
            load()
            return
        }

        ad.present(fromRootViewController: vc)
        isReady = false
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        load()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
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
