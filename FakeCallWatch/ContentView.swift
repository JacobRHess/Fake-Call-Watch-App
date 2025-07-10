import SwiftUI

struct ContentView: View {
    @State private var showFakeCall = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "phone.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.green)
                    .font(.system(size: 50))
                
                Text("Fake Call App")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Use your Apple Watch to trigger realistic fake calls!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .padding()
            
            if showFakeCall {
                FakeCallView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showFakeCall)) { _ in
            print("ContentView received showFakeCall notification")
            withAnimation(.easeInOut(duration: 0.3)) {
                showFakeCall = true
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active && showFakeCall {
                // Ensure call screen stays visible when app becomes active
            }
        }
    }
}

extension Notification.Name {
    static let showFakeCall = Notification.Name("showFakeCall")
}
