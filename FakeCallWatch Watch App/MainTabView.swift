import SwiftUI
import WatchConnectivity

struct MainTabView: View {
    @State private var selectedTimer: Int = 0
    @State private var autoTriggered = false
    @Environment(\.scenePhase) private var scenePhase
    
    private func sendFakeCallMessage() {
        print("Watch button pressed!")
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["command": "fakeCall"], replyHandler: nil) { error in
                print("error sending message:\(error.localizedDescription)")
            }
            print("Message sent to phone")
        } else {
            print("iPhone is not reachable")
        }
    }

    var body: some View {
        TabView {
            VStack {
                Text("Timer Settings")
                    .font(.headline)
                
                VStack(spacing: 10) {
                    Button("Immediate") {
                        selectedTimer = 0
                    }
                    .background(selectedTimer == 0 ? Color.blue : Color.gray)
                    
                    Button("30 Seconds") {
                        selectedTimer = 30
                    }
                    .background(selectedTimer == 30 ? Color.blue : Color.gray)
                    
                    Button("1 Minute") {
                        selectedTimer = 60
                    }
                    .background(selectedTimer == 60 ? Color.blue : Color.gray)
                    
                    Button("2 Minutes") {
                        selectedTimer = 120
                    }
                    .background(selectedTimer == 120 ? Color.blue : Color.gray)
                }
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            
            VStack {
                Text("Need to Escape?")
                    .font(.headline)
                
                if selectedTimer > 0 {
                    Text("Call in \(selectedTimer) seconds")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Button("Call me Now") {
                    if selectedTimer == 0 {
                        sendFakeCallMessage()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(selectedTimer)) {
                            sendFakeCallMessage()
                        }
                    }
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .tabItem {
                Image(systemName: "phone.fill")
                Text("Call")
            }
        }
        .onAppear {
            if WCSession.isSupported() {
                WCSession.default.delegate = WatchSessionDelegate.shared
                WCSession.default.activate()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active && !autoTriggered {
                // Auto-trigger call when app becomes active (from complication tap)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if selectedTimer == 0 {
                        sendFakeCallMessage()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(selectedTimer)) {
                            sendFakeCallMessage()
                        }
                    }
                    autoTriggered = true
                }
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
