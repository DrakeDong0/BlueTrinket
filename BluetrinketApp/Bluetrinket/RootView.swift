import SwiftUI

struct RootView: View {
    @StateObject var AuthModel = AuthViewModel()

    var body: some View {
        ZStack {
            if AuthModel.isAuthenticated {
                NavigationStack(path: $AuthModel.navigationPath) {
                    HomePage()
                        .navigationDestination(for: AppPage.self) { page in
                            switch page {
                            case .home:
                                HomePage()
                            case .settings:
                                SettingsPage()
                            case .map_settings:
                                MapSettingsPage()
                            case .account_settings:
                                AccountSettingsPage()
                            case .privacy_settings:
                                PrivacySettingsPage()
                            case .stats_settings:
                                StatsSettingsPage()
                            default:
                                ErrorPage(message: "Unknown page: \(String(describing: page))")
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
    case map_settings
    case account_settings
    case privacy_settings
    case stats_settings
}
