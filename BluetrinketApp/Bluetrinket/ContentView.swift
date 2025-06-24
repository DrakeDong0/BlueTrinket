//
//  ContentView.swift
//  Bluetrinket
//
//  Created by Drake Dong on 2025-06-21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var cameraPosition = MapCameraPosition.region(
        .init(center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
              latitudinalMeters: 13000,
              longitudinalMeters: 13000)
    )
    
    let locationManager = CLLocationManager()
    
    
    
    var body: some View {
        ZStack{
            Map(initialPosition: cameraPosition){
//                Marker("Apple visitor center", systemImage: "laptopcomputer", coordinate: .appleVisitorCenter)
                UserAnnotation()
            }
            .tint(.orange)
            .onAppear{
                locationManager.requestAlwaysAuthorization()
            }
            .mapControls{
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .mapStyle(.hybrid(elevation: .realistic))

            VStack{
//                Image("niagarafalls")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .cornerRadius(10)
//                    .padding(.all)
//                Text("Stuff here").font(.body)
            }
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
}

#Preview {
    ContentView()
}

extension CLLocationCoordinate2D{
    static let appleHQ = CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090)
    static let appleVisitorCenter = CLLocationCoordinate2D(latitude: 37.332753, longitude: -122.018715)
    static let panamaPark = CLLocationCoordinate2D(latitude: 37.347730, longitude: -122.018715)
}
