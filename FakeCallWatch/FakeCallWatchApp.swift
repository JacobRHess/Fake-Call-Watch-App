import SwiftUI
import WatchConnectivity
import UserNotifications

@main
struct FakeCallWatchApp: App {
    
    init() {
        if WCSession.isSupported() {
            WCSession.default.delegate = PhoneSessionDelegate.shared
            WCSession.default.activate()
            print("Phone: WCSession setup completed")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge, .criticalAlert]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
        
        UNUserNotificationCenter.current().delegate = PhoneSessionDelegate.shared
        PhoneSessionDelegate.shared.setupNotificationActions()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
