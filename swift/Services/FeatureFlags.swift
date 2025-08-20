import Foundation

enum FeatureFlags {
    /// While you're on Windows, keep this true (uses local mock). Switch to false on Mac to hit FastAPI.
    static var useMockPayments: Bool = true
}
