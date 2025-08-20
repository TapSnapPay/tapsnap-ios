import Foundation

enum CurrencyFormatter {
    /// Convert user-entered amount text like "12.34" into cents (1234)
    static func cents(fromUserAmount text: String) -> Int {
        let cleaned = text.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        // Prevent multiple decimals
        let parts = cleaned.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
        var major = parts.first ?? "0"
        var minor = parts.count > 1 ? parts[1] : "0"
        if minor.count > 2 { minor = String(minor.prefix(2)) }
        if major.isEmpty { major = "0" }
        let cents = (Int(major) ?? 0) * 100 + (Int(minor) ?? 0)
        return cents
    }
    
    /// Display cents as $X.YY
    static func display(fromCents cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = "USD"
        return nf.string(from: NSNumber(value: dollars)) ?? "$0.00"
    }
}
