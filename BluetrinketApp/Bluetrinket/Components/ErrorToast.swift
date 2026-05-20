import SwiftUI

struct ErrorToast: View {
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.white)
            Text(message)
                .foregroundColor(.white)
                .font(.subheadline)
            Spacer()
            Button {
                withAnimation { isShowing = false }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.red.opacity(0.9))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
