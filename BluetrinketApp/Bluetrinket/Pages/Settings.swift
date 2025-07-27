import SwiftUI
import MapKit
let spacingLeft: CGFloat = 30

struct SettingsRow: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(label).padding(.leading, 5)
                Spacer()
            }
            
        }.padding(.leading, spacingLeft)
    }
}
struct SettingsPage: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    @State private var notificationToggle = false

    var body: some View {
        ZStack {
            // Make sure this is at the base level
            Color(CustomColors.whiteColor)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 30) {
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
                    Text("Settings")
                        .foregroundColor(CustomColors.indigoColor)
                )

                VStack(spacing: 20) {
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .frame(height: 1)

                    HStack {
                        Image(systemName: "bell")
                            .padding(.leading, spacingLeft)
                        Toggle(isOn: $notificationToggle) {
                            Text("Notifications")
                        }
                        .padding(.leading, 5)
                        .padding(.trailing, 30)
                    }
                }

                SettingsRow(icon: "map", label: "Map Settings") {
                    AuthModel.navigationPath.append(.map_settings)
                }
                SettingsRow(icon: "person.crop.circle", label: "Account") {
                    AuthModel.navigationPath.append(.account_settings)
                }
                SettingsRow(icon: "lock", label: "Privacy and Permissions") {
                    AuthModel.navigationPath.append(.privacy_settings)
                }
                SettingsRow(icon: "chart.bar.yaxis", label: "Stats") {
                    AuthModel.navigationPath.append(.stats_settings)
                }
                SettingsRow(icon: "rectangle.portrait.and.arrow.right", label: "Log Out") {
                    AuthModel.logout()
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 20) // Optional, but ensure you’re not pushing content away from the top too far
        }
        .foregroundColor(.black)
        .font(.title2)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsPage()
}
