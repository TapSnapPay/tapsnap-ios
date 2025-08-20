import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var app: AppState
    
    var body: some View {
        Form {
            Section(header: Text("Payments")) {
                Toggle("Enable Tips", isOn: $app.tippingEnabled)
                Stepper("Default Tip: \(app.defaultTipPercent)%", value: $app.defaultTipPercent, in: 0...30, step: 5)
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("0.1.0").foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") { app.flow = .amountEntry }
            }
        }
    }
}
