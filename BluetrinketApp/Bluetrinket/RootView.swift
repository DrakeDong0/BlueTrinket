import SwiftUI

enum AppPage: Hashable {
    case home
    case settings
    case map_settings
    case account_settings
    case privacy_settings
    case stats_settings
}

struct RootView: View {
    @StateObject private var authModel = AuthViewModel()

    var body: some View {
        if authModel.isAuthenticated {
            NavigationStack(path: $authModel.navigationPath) {
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
                        }
                    }
            }
            .environmentObject(authModel)
        } else {
            LoginScreen()
                .environmentObject(authModel)
        }
    }
}
