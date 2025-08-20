import Foundation

struct PaymentIntentRequest: Codable {
    let amountCents: Int
    let tipPercent: Int
    let currency: String
}

struct PaymentIntentResponse: Codable {
    let id: String
    let amountCents: Int
    let tipCents: Int
    let last4: String?
    let status: String?
}

enum BackendError: Error {
    case badStatus(Int)
    case invalidURL
}

enum BackendClient {
    static func createPaymentIntent(amountCents: Int, tipPercent: Int, currency: String = "USD") async throws -> PaymentIntentResponse {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/payments/intents")
        var req = URLRequest(url: url); req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = PaymentIntentRequest(amountCents: amountCents, tipPercent: tipPercent, currency: currency)
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw BackendError.badStatus(-1) }
        guard (200..<300).contains(http.statusCode) else { throw BackendError.badStatus(http.statusCode) }
        return try JSONDecoder().decode(PaymentIntentResponse.self, from: data)
    }

    static func capturePayment(id: String) async throws -> PaymentIntentResponse {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/payments/\(id)/capture")
        var req = URLRequest(url: url); req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw BackendError.badStatus(-1) }
        guard (200..<300).contains(http.statusCode) else { throw BackendError.badStatus(http.statusCode) }
        return try JSONDecoder().decode(PaymentIntentResponse.self, from: data)
    }

    static func sendReceipt(email: String, txnId: String) async throws {
        let url = AppConfig.apiBaseURL.appendingPathComponent("/receipts")
        var req = URLRequest(url: url); req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let payload = ["email": email, "transactionId": txnId]
        req.httpBody = try JSONSerialization.data(withJSONObject: payload)
        let (_, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw BackendError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1)
        }
    }
}
