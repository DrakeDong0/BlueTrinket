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
                    Picker("Select a fruit", selection: $selectedMapType) {
                        ForEach(mapTypes, id: \.self) { mapType in
                            Text(mapType)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .onChange(of: selectedMapType) { oldValue, newValue in
                    handleMapTypeChange(newValue)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                       
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
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    showErrorMessage("Failed to change map type: \(error.localizedDescription)")
                }
                return
            }
            
            // Here you could handle the response, e.g. check status code
            // For demo: let's say success always
            
            DispatchQueue.main.async {
                // Hide error if success
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
        .environmentObject(AuthViewModel()) // Needed for preview
}
