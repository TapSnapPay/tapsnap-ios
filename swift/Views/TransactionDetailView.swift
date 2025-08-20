import SwiftUI

struct TransactionDetailView: View {
    @EnvironmentObject var app: AppState
    let txn: Transaction
    
    var body: some View {
        VStack(spacing: 16) {
            Text(CurrencyFormatter.display(fromCents: txn.amountCents + txn.tipCents))
                .font(.system(size: 34, weight: .bold))
            
            HStack {
                Label("•••• \(txn.last4)", systemImage: "creditcard")
                Spacer()
                Label(txn.status == .approved ? "Approved" : "Declined", systemImage: txn.status == .approved ? "checkmark.circle" : "xmark.octagon")
                    .foregroundStyle(txn.status == .approved ? .green : .red)
            }
            
            HStack {
                Label(txn.date.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                Spacer()
                if txn.tipCents > 0 {
                    Label("Tip: \(CurrencyFormatter.display(fromCents: txn.tipCents))", systemImage: "percent")
                }
            }
            
            Spacer()
            
            PrimaryButton(title: "Send Receipt (stub)") {
                // TODO: integrate with backend later
            }
        }
        .padding()
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { app.flow = .transactionsList }
            }
        }
    }
}
