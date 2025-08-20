#if canImport(Adyen)
import Adyen
import Foundation

enum AdyenIntegration {
    /// Placeholder signature we'll call from the UI later.
    static func startTapToPay(amountCents: Int, tipPercent: Int) async throws {
        // TODO: Implement with Adyen's Tap to Pay session start.
        // This block will compile only when Adyen is added via SPM in Xcode.
    }
}
#else
import Foundation

enum AdyenIntegration {
    enum StubError: Error { case notAvailable }
    /// Fallback so the project builds without Adyen present.
    static func startTapToPay(amountCents: Int, tipPercent: Int) async throws {
        throw StubError.notAvailable
    }
}
#endif
