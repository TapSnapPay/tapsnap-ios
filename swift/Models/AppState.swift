import Foundation

struct Transaction: Identifiable, Hashable {
    let id = UUID()
    let amountCents: Int
    let tipCents: Int
    let date: Date
    let last4: String
    let status: Status
    
    enum Status: String {
        case approved, declined
    }
}

enum PaymentFlowState: Equatable {
    case amountEntry
    case tapPrompt
    case processing
    case result(success: Bool, txn: Transaction?)
    case transactionsList
    case transactionDetail(txn: Transaction)
    case settings
}

final class AppState: ObservableObject {
    @Published var flow: PaymentFlowState = .amountEntry
    @Published var amountText: String = "" // user-entered, supports decimal keypad
    @Published var tippingEnabled: Bool = true
    @Published var defaultTipPercent: Int = 15
    @Published var transactions: [Transaction] = []
    
    // Derived
    var amountCents: Int {
        CurrencyFormatter.cents(fromUserAmount: amountText)
    }
    
    func reset() {
        amountText = ""
        flow = .amountEntry
    }
}
