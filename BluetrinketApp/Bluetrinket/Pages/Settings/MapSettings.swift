import SwiftUI

struct MapSettingsPage: View {
    @EnvironmentObject var AuthModel: AuthViewModel

    @State private var selectedMapType = "Standard"
    let mapTypes = ["Standard", "Hybrid Realistic", "Satellite"]

    @State private var showError = false
    @State private var errorMessage = ""

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
                .onChange(of: selectedMapType) { _, newValue in
                    handleMapTypeChange(newValue)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if showError {
                VStack {
                    ErrorToast(message: errorMessage, isShowing: $showError)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
                .padding(.top, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .foregroundColor(.black)
        .font(.title2)
        .animation(.easeInOut, value: showError)
    }

    func handleMapTypeChange(_ selected: String) {
        guard let url = URL(string: "http://localhost:8010/changeMapType") else {
            showErrorMessage("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { _, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    showErrorMessage("Failed to change map type: \(error.localizedDescription)")
                }
                return
            }

            DispatchQueue.main.async {
                showError = false
            }
        }

        task.resume()
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        withAnimation {
            showError = true
        }
    }
}

#Preview {
    MapSettingsPage()
        .environmentObject(AuthViewModel())
}
