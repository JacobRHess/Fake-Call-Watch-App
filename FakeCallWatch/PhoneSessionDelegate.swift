import Foundation
import WatchConnectivity
import UserNotifications
import UIKit
import AudioToolbox

class PhoneSessionDelegate: NSObject, WCSessionDelegate {
    static let shared = PhoneSessionDelegate()
    
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Phone session activated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Phone Received message: \(message)")
        if message["command"] as? String == "fakeCall" {
            print("Received 'fakeCall' from watch")
            showFakeCallNotification()
        }
    }
    
    private func showFakeCallNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Mom"
        content.subtitle = "iPhone"
        content.body = "Incoming call..."
        content.sound = UNNotificationSound(named: UNNotificationSoundName("opening.caf"))
        content.interruptionLevel = .critical
        content.categoryIdentifier = "FAKE_CALL_CATEGORY"
        
        // Add call-like threading to group with other "calls"
        content.threadIdentifier = "incoming-call"
        
        let uniqueID = "fake_call_\(Date().timeIntervalSince1970)_\(UUID().uuidString)"
        let request = UNNotificationRequest(
            identifier: uniqueID,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showFakeCall, object: nil)
        }
    }
}

extension PhoneSessionDelegate: UNUserNotificationCenterDelegate {
    func setupNotificationActions() {
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_CALL",
            title: "Accept",
            options: [.foreground]
        )
        
        let declineAction = UNNotificationAction(
            identifier: "DECLINE_CALL",
            title: "Decline",
            options: [.destructive]
        )
        
        let callCategory = UNNotificationCategory(
            identifier: "FAKE_CALL_CATEGORY",
            actions: [acceptAction, declineAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([callCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "ACCEPT_CALL":
            print("User accepted fake call")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .showFakeCall, object: nil)
            }
        case "DECLINE_CALL":
            print("User declined fake call")
        default:
            break
        }
        
        completionHandler()
    }
}
