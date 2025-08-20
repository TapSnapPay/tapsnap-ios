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
        .onAppear { Task { await runFlow() } }
        .padding()
    }

    func runFlow() async {
        do {
            let tipPercent = app.tippingEnabled ? app.defaultTipPercent : 0

            if FeatureFlags.useMockPayments {
                let txn = try await PaymentServiceMock.authorize(amountCents: app.amountCents, tipPercent: tipPercent)
                app.transactions.insert(txn, at: 0)
                Haptics.success()
                app.flow = .result(success: true, txn: txn)
            } else {
                // 1) create intent
                let intent = try await BackendClient.createPaymentIntent(amountCents: app.amountCents, tipPercent: tipPercent)
                // 2) capture
                _ = try await BackendClient.capturePayment(id: intent.id)

                // 3) convert to UI Transaction
                let txn = Transaction(
                    amountCents: intent.amountCents,
                    tipCents: intent.tipCents,
                    date: Date(),
                    last4: intent.last4 ?? "0000",
                    status: .approved
                )
                app.transactions.insert(txn, at: 0)
                Haptics.success()
                app.flow = .result(success: true, txn: txn)
            }
        } catch {
            Haptics.error()
            app.flow = .result(success: false, txn: nil)
        }
    }
}
