import SwiftUI
import Auth0

struct LoginScreen: View {
    @EnvironmentObject var AuthModel: AuthViewModel

    var body: some View {
        ZStack {
            // 1. Background color
            Color(CustomColors.whiteColor)
                .ignoresSafeArea()

            // 2. Main content
            VStack(alignment: .leading, spacing: 40) {
                Text("Hello!")
                    .font(.system(size: 65, weight: .bold))
                    .foregroundColor(CustomColors.indigoColor)

                (
                    Text("BlueTrinket")
                        .foregroundColor(CustomColors.indigoColor)
                    + Text(" maps your world by unveiling places you’ve visited.")
                        .foregroundColor(.gray)
                )
                .font(.system(size: 25, weight: .medium))

                Button("Get Started →") {
                    AuthModel.login()
                }
                .padding()
                .background(CustomColors.indigoColor)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding(.top, 120)
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            // 3. Footer image absolutely positioned at bottom
            Image("wave_footer")
                .resizable()
                .scaledToFit()
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
                .zIndex(10)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginScreen()
}
