import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        VStack {
           Text("Need to Escape?")
                .font(.headline)
            
            Button(action: {
                print("Watch button pressed")
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(["command": "fakeCall"], replyHandler: nil) { error in
                        print("error sending message:\(error.localizedDescription)")
                    }
                    print("message sent to phone")
                } else {
                    print("iPhone is not reachable")
                }
            }) {
                Text("Call me Now")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
        .onAppear(){
            if WCSession.isSupported(){
                WCSession.default.delegate = WatchSessionDelegate.shared
                WCSession.default.activate()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
