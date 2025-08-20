import Foundation

enum PaymentServiceMock {
    static func authorize(amountCents: Int, tipPercent: Int) async throws -> Transaction {
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s
        
        let approved = Bool.random(probability: 0.85)
        if !approved {
            throw NSError(domain: "mock", code: 1, userInfo: [NSLocalizedDescriptionKey : "Declined"])
        }
        
        let tipCents = Int((Double(amountCents) * Double(tipPercent) / 100.0).rounded())
        let last4 = String(format: "%04d", Int.random(in: 0...9999))
        
        return Transaction(
            amountCents: amountCents,
            tipCents: tipCents,
            date: Date(),
            last4: last4,
            status: .approved
        )
    }
}

extension Bool {
    /// Returns true with the given probability (0.0 - 1.0)
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}
