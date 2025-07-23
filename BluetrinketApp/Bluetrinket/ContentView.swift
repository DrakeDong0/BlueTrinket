import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var AuthModel: AuthViewModel
    @State var cameraPosition = MapCameraPosition.region(
        .init(center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
              latitudinalMeters: 13000,
              longitudinalMeters: 13000)
    )
    
    let locationManager = CLLocationManager()
    @State private var mapType = MapVersion.standard
    @State private var responseText = "no response text"

    let collapsedOffset: CGFloat = 360
    let expandedOffset: CGFloat = 100
    
    @State private var sheetPosition: CGFloat = 360
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Settings
            VStack{
                HStack {
                    Button(action: {
                        AuthModel.changePage(1)
                    }){Image(systemName: "gearshape.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.gray).opacity(0.7)
                            .zIndex(1)
                            .ignoresSafeArea()
                        Spacer()
                    }.padding(.top, 6)
                        .padding(.leading, 6)
                }
                Spacer()
            }.zIndex(2)
            // Map
            Map(initialPosition: cameraPosition) {
                UserAnnotation()
            }
            .padding(.bottom, 40)
            .tint(CustomColors.indigoColor)
            .onAppear {
                locationManager.requestAlwaysAuthorization()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .mapStyle(mapType)

            // 3. Swipe-Up Tab
            VStack {
                Spacer()
                VStack {
                    Capsule()
                        .frame(width: 50, height: 6)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.top, 6)
                    HStack{
                        Text("Swipe-Up Tab")
                            .padding(.bottom)
                            .padding(.top, 6)
                        Button("Logout") {
                            AuthModel.logout()
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 450)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .offset(y: sheetPosition + dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let totalDrag = sheetPosition + gesture.translation.height
                            if totalDrag < expandedOffset {
                                dragOffset = expandedOffset - sheetPosition
                            } else if totalDrag > collapsedOffset {
                                dragOffset = collapsedOffset - sheetPosition
                            } else {
                                dragOffset = gesture.translation.height
                            }
                        }
                        .onEnded { gesture in
                            withAnimation(.interactiveSpring()) {
                                let threshold: CGFloat = 70
                                if gesture.translation.height < -threshold {
                                    sheetPosition = expandedOffset
                                } else if gesture.translation.height > threshold {
                                    sheetPosition = collapsedOffset
                                }
                                else {
                                    if sheetPosition + dragOffset < (collapsedOffset + expandedOffset)/2 {
                                        sheetPosition = expandedOffset
                                    } else {
                                        sheetPosition = collapsedOffset
                                    }
                                }
                                dragOffset = 0
                            }
                        }
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .zIndex(1)
        }
    }

    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        do {
            let update = try await updates.first { $0.location?.coordinate != nil }
            return update?.location?.coordinate
        } catch {
            print("Cannot get user location")
            return nil
        }
    }

    func callBackend() {
        guard let url = URL(string: "http://localhost:8010/test") else {
            responseText = "Invalid URL"
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseText = "Error: \(error.localizedDescription)"
                }
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseText = "Response: \(responseString)"
                }
            }
        }

        task.resume()
    }
}

#Preview {
    ContentView()
}

