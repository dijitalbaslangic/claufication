import SwiftUI

@MainActor
let sharedMonitor: ClaudeSessionMonitor = {
    let m = ClaudeSessionMonitor()
    m.start()
    return m
}()

@main
struct ClauficationApp: App {
    var body: some Scene {
        MenuBarExtra {
            MenuBarView(monitor: sharedMonitor)
                .onAppear {
                    sharedMonitor.clearNotification()
                }
        } label: {
            Image(systemName: sharedMonitor.hasNotification ? "bell.badge.fill" : "bell.fill")
        }
        .menuBarExtraStyle(.window)
    }
}
