import SwiftUI

struct MenuBarView: View {
    @Bindable var monitor: ClaudeSessionMonitor
    @AppStorage("selectedSound") private var selectedSound = "Glass"
    @AppStorage("volume") private var volume: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Status
            statusSection

            Divider()

            // Sound Settings
            soundSection

            Divider()

            // Actions
            HStack {
                Button("Test Sound") {
                    monitor.soundManager.play()
                }

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .padding(12)
        .frame(width: 260)
        .onAppear {
            monitor.soundManager.selectedSound = selectedSound
            monitor.soundManager.volume = Float(volume)
        }
    }

    private var statusSection: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(monitor.state.rawValue)
                    .font(.headline)
                    .lineLimit(1)

                if let file = monitor.currentFile {
                    let name = (file as NSString).lastPathComponent
                    Text(name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                } else {
                    Text(monitor.isClaudeRunning ? "No active session" : "Claude not running")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

            }
        }
    }

    private var statusColor: Color {
        switch monitor.state {
        case .idle:
            return .gray
        case .working:
            return .green
        case .waitingInput:
            return .orange
        }
    }

    private var soundSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("Sound", selection: $selectedSound) {
                ForEach(SoundManager.availableSounds, id: \.self) { name in
                    Text(name).tag(name)
                }
            }
            .onChange(of: selectedSound) { _, newValue in
                monitor.soundManager.selectedSound = newValue
            }

            HStack(spacing: 8) {
                Image(systemName: "speaker.fill")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Slider(value: $volume, in: 0...1)
                    .onChange(of: volume) { _, newValue in
                        monitor.soundManager.volume = Float(newValue)
                    }
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}
