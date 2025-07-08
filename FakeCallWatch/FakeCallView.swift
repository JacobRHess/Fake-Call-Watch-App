import SwiftUI

struct FakeCallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isCallActive = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Mom")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                    
                    Text("mobile")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("+1 (555) 123-4567")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if !isCallActive {
                    HStack(spacing: 80) {
                        Button(action: declineCall) {
                            Image(systemName: "phone.down.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 65, height: 65)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        
                        Button(action: acceptCall) {
                            Image(systemName: "phone.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 65, height: 65)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("00:05")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Button(action: endCall) {
                            Image(systemName: "phone.down.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 65, height: 65)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 80)
            }
        }
        .onAppear {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func acceptCall() {
        withAnimation {
            isCallActive = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            endCall()
        }
    }
    
    private func declineCall() {
        dismiss()
    }
    
    private func endCall() {
        dismiss()
    }
}
