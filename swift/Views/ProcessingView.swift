import SwiftUI

struct ProcessingView: View {
    @EnvironmentObject var app: AppState
    @State private var isWorking = true
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView("Processing…")
                .progressViewStyle(.circular)
                .font(.system(size: 18, weight: .medium))
        }
        .onAppear {
            Task { await runMock() }
        }
        .padding()
    }
    
    func runMock() async {
        do {
            let txn = try await PaymentServiceMock.authorize(amountCents: app.amountCents, tipPercent: app.tippingEnabled ? app.defaultTipPercent : 0)
            app.transactions.insert(txn, at: 0)
            Haptics.success()
            app.flow = .result(success: true, txn: txn)
        } catch {
            Haptics.error()
            app.flow = .result(success: false, txn: nil)
        }
    }
}
