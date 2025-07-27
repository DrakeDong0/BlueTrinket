import SwiftUI

struct ErrorPage: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    var message: String
    
    var body: some View {
        ZStack{
            Color(CustomColors.whiteColor)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Error")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    ErrorPage(message: "Preview error message")
        .environmentObject(AuthViewModel())
}
