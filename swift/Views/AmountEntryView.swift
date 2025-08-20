import SwiftUI

struct AmountEntryView: View {
    @EnvironmentObject var app: AppState
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Enter Amount")
                .font(.system(size: 24, weight: .semibold))
            
            Text(CurrencyFormatter.display(fromCents: app.amountCents))
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(.vertical, 8)
            
            HStack {
                Toggle("Enable tips", isOn: $app.tippingEnabled)
                Spacer()
                if app.tippingEnabled {
                    Stepper(value: $app.defaultTipPercent, in: 0...30, step: 5) {
                        Text("Tip: \(app.defaultTipPercent)%")
                    }.frame(width: 160)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            Keypad(amountText: $app.amountText)
                .frame(maxWidth: 380)
            
            PrimaryButton(title: "Charge \(CurrencyFormatter.display(fromCents: totalWithTip))", disabled: app.amountCents == 0) {
                app.flow = .tapPrompt
            }
            .padding(.top, 8)
            
            Spacer()
            
            HStack {
                Button("Transactions") { app.flow = .transactionsList }
                Spacer()
                Button("Settings") { app.flow = .settings }
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var totalWithTip: Int {
        guard app.tippingEnabled else { return app.amountCents }
        let tip = Int((Double(app.amountCents) * Double(app.defaultTipPercent) / 100.0).rounded())
        return app.amountCents + tip
    }
}

struct Keypad: View {
    @Binding var amountText: String
    
    private let rows: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        [".","0","⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { key in
                        Button {
                            tap(key)
                        } label: {
                            Text(key)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }
            }
        }
    }
    
    func tap(_ key: String) {
        switch key {
        case "⌫":
            if !amountText.isEmpty { amountText.removeLast() }
        case ".":
            if !amountText.contains(".") { amountText.append(".") }
        default:
            amountText.append(key)
        }
        // sanitize: max two decimals
        let parts = amountText.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        if parts.count == 2 && parts[1].count > 2 {
            amountText = parts[0] + "." + String(parts[1].prefix(2))
        }
        // prevent leading zeros like "0005"
        if amountText.hasPrefix("0") && !amountText.hasPrefix("0.") {
            amountText = String(Int(amountText) ?? 0)
        }
    }
}
