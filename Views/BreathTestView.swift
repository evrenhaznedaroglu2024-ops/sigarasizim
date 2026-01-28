import SwiftUI

struct BreathTestView: View {
    enum Phase: String { case inhale = "Nefes Al", hold = "Tut", exhale = "Ver" }

    @State private var phase: Phase = .inhale
    @State private var secondsLeft: Int = 4
    @State private var isRunning = false

    private let inhaleSec = 4
    private let holdSec = 4
    private let exhaleSec = 6

    var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                Text("Nefes Egzersizi").font(.title2.bold())

                VStack(spacing: 6) {
                    Text(phase.rawValue).font(.headline)
                    Text("\(secondsLeft)")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .cornerRadius(16)
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button(isRunning ? "Durdur" : "Başlat") {
                        isRunning.toggle()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Sıfırla") { reset() }
                        .buttonStyle(.bordered)
                }

                Spacer()

                BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                    .frame(height: 50)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .padding(.top, 16)
            .navigationTitle("Test")
        }
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
