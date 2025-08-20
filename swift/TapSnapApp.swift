import SwiftUI

@main
struct TapSnapApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var app: AppState
    
    var body: some View {
        NavigationStack {
            switch app.flow {
            case .amountEntry:
                AmountEntryView()
            case .tapPrompt:
                TapPromptView()
            case .processing:
                ProcessingView()
            case .result(let success, let txn):
                ResultView(success: success, txn: txn)
            case .transactionsList:
                TransactionsListView()
            case .transactionDetail(let txn):
                TransactionDetailView(txn: txn)
            case .settings:
                SettingsView()
            }
        }
        .tint(Theme.brand)
    }
}
