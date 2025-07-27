import SwiftUI

struct SettingsHeader: View{
    @EnvironmentObject var AuthModel: AuthViewModel
    var title: String
    
    var body: some View{
        HStack {
            Button(action: {
                AuthModel.navigationPath.removeLast()
            }) {
                Image(systemName: "arrow.backward")
            }
            Spacer()
        }.padding(.leading, spacingLeft)
            .foregroundColor(CustomColors.indigoColor)
            .overlay(
                Text(title)
            ).foregroundColor(CustomColors.indigoColor)
        Divider()
            .background(Color.gray.opacity(0.5))
            .frame(height: 1)
    }
}
