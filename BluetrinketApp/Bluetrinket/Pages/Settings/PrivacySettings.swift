import SwiftUI

struct PrivacySettingsPage: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    
    var body: some View{
        ZStack {
            Color(CustomColors.whiteColor)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 30) {
                SettingsHeader(title: "Privacy Settings")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .foregroundColor(.black)
        .font(.title2)
    }
}

#Preview {
    PrivacySettingsPage()
}
