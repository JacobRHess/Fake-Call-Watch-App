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
        if WCSession.isSupported() && WCSession.default.isReachable {
            WCSession.default.sendMessage(["command": "fakeCall"], replyHandler: nil) { error in
                print("Complication error: \(error.localizedDescription)")
            }
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
