import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var app: AppState
    
    var body: some View {
        List(app.transactions) { txn in
            Button {
                app.flow = .transactionDetail(txn: txn)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(CurrencyFormatter.display(fromCents: txn.amountCents + txn.tipCents))
                            .font(.system(size: 17, weight: .semibold))
                        Text(txn.date.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    Spacer()
                    Text(txn.status == .approved ? "Approved" : "Declined")
                        .font(.footnote)
                        .foregroundStyle(txn.status == .approved ? .green : .red)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New") { app.reset() }
            }
        }
    }
}
