import SwiftUI

struct RootView: View {
    @StateObject var AuthModel = AuthViewModel()


    var body: some View {
        ZStack {
            if AuthModel.isAuthenticated {
                NavigationStack(path: $AuthModel.navigationPath){
                    HomePage()
                        .navigationDestination(for: AppPage.self) { page in
                            switch page {
                            case .home:
                                HomePage()
                            case .settings:
                                SettingsScreen()
                            }
                        }
                }
            } else {
                LoginScreen()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .environmentObject(AuthModel)
        .animation(.easeInOut, value: AuthModel.isAuthenticated)
    }
}

enum AppPage: Hashable {
    case home
    case settings
}
