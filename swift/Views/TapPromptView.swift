import SwiftUI

struct TapPromptView: View {
    @EnvironmentObject var app: AppState
    @State private var anim = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ready for customer to tap")
                .font(.system(size: 24, weight: .semibold))
            
            RoundedRectangle(cornerRadius: 24)
                .stroke(Theme.brand, lineWidth: 4)
                .frame(width: 220, height: 140)
                .overlay(
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 48))
                )
                .scaleEffect(anim ? 1.03 : 0.97)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: anim)
                .onAppear { anim = true }
            
            Text("Ask the customer to hold their card or phone near the top of your iPhone.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            PrimaryButton(title: "Simulate Tap") {
                app.flow = .processing
            }
            
            Button("Back") { app.flow = .amountEntry }
                .padding(.top, 8)
        }
        .padding()
    }
}
