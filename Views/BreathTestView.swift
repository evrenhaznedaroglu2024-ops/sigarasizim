import SwiftUI
import Combine

struct BreathTestView: View {
    @EnvironmentObject var store: AppStore

    enum Phase {
        case inhale, hold, exhale
        
        var color: Color {
            switch self {
            case .inhale: return .cyan
            case .hold: return .orange
            case .exhale: return .green
            }
        }
        
        func text(language: AppLanguage) -> String {
            switch self {
            case .inhale: return Localization.shared.string("breath_inhale", for: language)
            case .hold: return Localization.shared.string("breath_hold", for: language)
            case .exhale: return Localization.shared.string("breath_exhale", for: language)
            }
        }
    }

    @State private var phase: Phase = .inhale
    @State private var secondsLeft: Int = 4
    @State private var isRunning = false

    private let inhaleSec = 4
    private let holdSec = 4
    private let exhaleSec = 6

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    Text(Localization.shared.string("breath_desc", for: store.settings.language))
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 16)

                    // Animation Area
                    ZStack {
                        if isRunning {
                            Circle()
                                .fill(phase.color.opacity(0.2))
                                .frame(width: 250, height: 250)
                                .scaleEffect(phase == .inhale ? 1.0 : (phase == .exhale ? 0.5 : 1.0))
                                .animation(.easeInOut(duration: phase == .inhale ? Double(inhaleSec) : (phase == .exhale ? Double(exhaleSec) : 0)), value: phase)
                            
                            Circle()
                                .fill(phase.color.opacity(0.4))
                                .frame(width: 200, height: 200)
                                .scaleEffect(phase == .inhale ? 1.0 : (phase == .exhale ? 0.5 : 1.0))
                                .animation(.easeInOut(duration: phase == .inhale ? Double(inhaleSec) : (phase == .exhale ? Double(exhaleSec) : 0)), value: phase)

                            Text(phase.text(language: store.settings.language))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(phase.color)
                                .transition(.opacity)
                        } else {
                            // Resting State
                            Image(systemName: "lungs.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.secondary.opacity(0.3))
                        }

                        if isRunning {
                            Text("\(secondsLeft)")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundColor(.primary)
                                .offset(y: 40) // Move text lower
                        }
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)

                    HStack(spacing: 12) {
                        Button(isRunning ? Localization.shared.string("breath_stop", for: store.settings.language) : Localization.shared.string("breath_start", for: store.settings.language)) {
                            withAnimation {
                                isRunning.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)

                        if isRunning {
                             Button(Localization.shared.string("breath_reset", for: store.settings.language)) { reset() }
                                 .buttonStyle(.bordered)
                                 .controlSize(.regular)
                        }
                    }

                    Spacer()

                    BannerAdView(adUnitID: AdConfig.bannerID)
                        .frame(height: 50)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                }
            }
            .navigationTitle(Localization.shared.string("breath_title", for: store.settings.language))
        }
        .navigationViewStyle(.stack)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard isRunning else { return }
            tick()
        }
    }

    private func reset() {
        isRunning = false
        phase = .inhale
        secondsLeft = inhaleSec
    }

    private func tick() {
        if secondsLeft > 1 {
            secondsLeft -= 1
            return
        }

        switch phase {
        case .inhale:
            phase = .hold
            secondsLeft = holdSec
        case .hold:
            phase = .exhale
            secondsLeft = exhaleSec
        case .exhale:
            phase = .inhale
            secondsLeft = inhaleSec
        }
    }
}
