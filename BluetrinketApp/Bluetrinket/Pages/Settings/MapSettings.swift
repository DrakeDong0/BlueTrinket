import SwiftUI

struct MapSettingsPage: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    
    @State private var selectedMapType = "Standard"
    let mapTypes = ["Standard", "Hybrid Realistic", "Satellite"]
    
    var body: some View {
        ZStack {
            Color(CustomColors.whiteColor)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 30) {
                SettingsHeader(title: "Map Settings")
                    .padding(.top, 20)

                HStack {
                    Text("Map Type:")
                    Spacer()
                    Picker("Map Type", selection: $selectedMapType) {
                        ForEach(mapTypes, id: \.self) { mapType in
                            Text(mapType)
                        }
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .foregroundColor(.black)
        .font(.title2)
    }
}


#Preview {
    MapSettingsPage()
        .environmentObject(AuthViewModel()) // Needed for preview
}
