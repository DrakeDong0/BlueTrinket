import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    var body: some View {
        ZStack {
            Text("settings")
            
        }
    }
}

#Preview {
    SettingsScreen()
}
