import SwiftUI

struct RootView: View {
    @StateObject var AuthModel = AuthViewModel()

    var body: some View {
        ZStack {
            ContentView()
                .blur(radius: AuthModel.isAuthenticated ? 0 : 10)
                .disabled(!AuthModel.isAuthenticated)

            if !AuthModel.isAuthenticated {
                LoginScreen()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .environmentObject(AuthModel)
        .animation(.easeInOut, value: AuthModel.isAuthenticated)
    }
}
