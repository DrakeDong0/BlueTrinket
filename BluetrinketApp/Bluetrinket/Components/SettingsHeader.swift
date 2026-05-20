import SwiftUI

struct SettingsHeader: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    let title: String

    var body: some View {
        HStack {
            Button(action: {
                AuthModel.navigationPath.removeLast()
            }) {
                Image(systemName: "arrow.backward")
            }
            Spacer()
        }
        .padding(.leading, spacingLeft)
        .foregroundColor(CustomColors.indigoColor)
        .overlay(
            Text(title)
                .foregroundColor(CustomColors.indigoColor)
        )
    }
}
