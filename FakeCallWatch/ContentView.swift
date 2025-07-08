import SwiftUI

struct ContentView: View {
    @State private var showFakeCall = false
    
    var body: some View {
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
        .fullScreenCover(isPresented: $showFakeCall) {
            FakeCallView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .showFakeCall)) { _ in
            print("ContentView received showFakeCall notification")
            showFakeCall = true
        }
    }
}

extension Notification.Name {
    static let showFakeCall = Notification.Name("showFakeCall")
}
