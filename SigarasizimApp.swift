import SwiftUI
import AppTrackingTransparency
import AdSupport

@main
struct SigarasizimApp: App {
    @StateObject private var store = AppStore()
    @Environment(\.scenePhase) private var scenePhase


    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(store)
                .onAppear {
                    // Delay slightly to ensure view is ready
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        requestATT()
                    }
                }
        }
    }
    
    private func requestATT() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    // Initialize AdMob regardless of status, it handles consent internally or runs non-personalized
                    AdMobManager.shared.start()
                    
                    switch status {
                    case .authorized:
                        print("ATT: Authorized")
                    case .denied:
                        print("ATT: Denied")
                    case .restricted:
                        print("ATT: Restricted")
                    case .notDetermined:
                        print("ATT: Not Determined")
                    @unknown default:
                        break
                    }
                }
            }
        } else {
            AdMobManager.shared.start()
        }
    }
}
