import SwiftUI

struct ResultView: View {
    @EnvironmentObject var app: AppState
    let success: Bool
    let txn: Transaction?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: success ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .font(.system(size: 72))
                .foregroundStyle(success ? .green : .red)
            
            Text(success ? "Payment Approved" : "Payment Declined")
                .font(.system(size: 24, weight: .semibold))
            
            if let txn {
                VStack(spacing: 6) {
                    Label(CurrencyFormatter.display(fromCents: txn.amountCents + txn.tipCents), systemImage: "dollarsign.circle")
                    Label("•••• \(txn.last4)", systemImage: "creditcard")
                    Label(txn.date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                }
                .foregroundStyle(.secondary)
            }
            
            PrimaryButton(title: "New Payment") {
                app.reset()
            }
            
            Button("View Transactions") { app.flow = .transactionsList }
                .padding(.top, 4)
        }
        .padding()
    }
}
