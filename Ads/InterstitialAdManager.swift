import Foundation
import Combine
import UIKit

struct AdConfig {
    static let appID = "ca-app-pub-1890131120074298~3101816142"
    static let bannerID = "ca-app-pub-1890131120074298/5344836105"
    static let interstitialID = "ca-app-pub-1890131120074298/9092509421"
}

#if canImport(GoogleMobileAds)
import GoogleMobileAds

final class InterstitialAdManager: NSObject, ObservableObject {

    @Published private(set) var isReady = false
    private var interstitial: InterstitialAd?

    private let adUnitID = AdConfig.interstitialID

    override init() {
        super.init()
        load()
    }

    func load() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.interstitial = ad
                self.isReady = (ad != nil)
            }
        }
    }

    func show() {
        guard let ad = interstitial,
              let vc = UIApplication.shared.topViewController()
        else { load(); return }

        ad.present(from: vc)
        interstitial = nil
        isReady = false
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
