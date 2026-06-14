import SwiftUI
import UIKit

#if canImport(GoogleMobileAds)
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        banner.rootViewController = scene?.windows.first?.rootViewController
        
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
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
                    Text("AdMob Banner (SDK Bekleniyor)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            )
            .frame(height: 50)
    }
}
#endif

// MARK: - UIApplication Extension
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
