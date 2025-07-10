import WidgetKit
import SwiftUI
import WatchConnectivity

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date())
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

class ComplicationSessionDelegate: NSObject, WCSessionDelegate {
    static let shared = ComplicationSessionDelegate()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Complication session activated: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Not needed for complication
    }
}

struct FakeCallComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Image(systemName: "phone.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.green)
            
            Text("Call")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white)
        }
        .onTapGesture {
            triggerFakeCall()
        }
    }
    
    private func triggerFakeCall() {
        guard WCSession.isSupported() else {
            print("WCSession not supported")
            return
        }
        
        let session = WCSession.default
        if session.activationState != .activated {
            session.delegate = ComplicationSessionDelegate.shared
            session.activate()
        }
        
        if session.isReachable {
            session.sendMessage(["command": "fakeCall"], replyHandler: nil) { error in
                print("Complication error: \(error.localizedDescription)")
            }
            print("Complication sent fake call message")
        } else {
            print("iPhone not reachable from complication")
        }
    }
}

@main
struct FakeCallComplication: Widget {
    let kind: String = "FakeCallComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FakeCallComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Fake Call")
        .description("Tap to trigger a fake call")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCorner
        ])
    }
}
