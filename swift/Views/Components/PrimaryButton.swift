import SwiftUI

struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .font(.system(size: 17, weight: .semibold))
                .background(disabled ? Theme.brand.opacity(0.4) : Theme.brand)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.brand600.opacity(0.3), lineWidth: 1)
                )
        }
        .disabled(disabled)
    }
}
