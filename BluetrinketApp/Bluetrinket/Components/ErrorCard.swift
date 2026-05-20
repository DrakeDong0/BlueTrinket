import SwiftUI

struct ErrorToast: View {
    let message: String
    @Binding var isShowing: Bool  

    var body: some View {
        if isShowing {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                    .font(.title2)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color.red.opacity(0.9))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 24)
            .frame(maxWidth: 400)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
