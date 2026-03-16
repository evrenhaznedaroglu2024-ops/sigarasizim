import SwiftUI
import UIKit

#if canImport(YandexMobileAds)
import YandexMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> AdView {
        let adSize = BannerAdSize.fixedSize(withWidth: 320, height: 50)
        let banner = AdView(adUnitID: adUnitID, adSize: adSize)
        banner.delegate = context.coordinator
        banner.loadAd()
        return banner
    }

    func updateUIView(_ uiView: AdView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, AdViewDelegate {
        func adViewDidLoad(_ adView: AdView) {
            print("Yandex Banner loaded")
        }

        func adViewDidFailToLoad(_ adView: AdView, error: AdRequestError) {
            print("Yandex Banner failed to load: \(error.error.localizedDescription)")
        }
    }
}
#else
struct BannerAdView: View {
    let adUnitID: String
    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.tertiarySystemBackground))
            .overlay(
                HStack(spacing: 8) {
                    Image(systemName: "megaphone")
                    Text("Reklam alanı (SDK yok)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            )
            .frame(height: 60)
    }
}
#endif


// MARK: - UIApplication Extension
// Added here because Extensions/UIApplication+TopViewController.swift is missing from Target
extension UIApplication {
    public func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC: UIViewController? = {
            if let base { return base }
            return connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        }()

        if let nav = baseVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = baseVC?.presentedViewController {
            return topViewController(base: presented)
        }
        return baseVC
    }
}
