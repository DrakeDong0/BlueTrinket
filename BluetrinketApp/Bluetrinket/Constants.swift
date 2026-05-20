import SwiftUI
import MapKit


// Colors
struct CustomColors {
    static let indigoColor = Color(red: 88/255, green: 86/255, blue: 214/255)
    static let whiteColor = Color(red: 1.0, green: 0.996, blue: 0.98)
}

// Map Settings
struct MapVersion{
    static let hybridRealistic = MapStyle.hybrid(elevation: .realistic)
    static let standard = MapStyle.standard
    static let satellite = MapStyle.imagery(elevation: .realistic)
}

//auth0 info
struct authData{
    static let clientID = "cdu0WLFF6BVfgKUBVRQw7K6eIo8q9YOD"
    static let domain = "dev-oxiw8y8jzhq1qfel.us.auth0.com"
    static let redirectURL = "com.drakedong.Bluetrinket://com.drakedong.Bluetrinket/callback"
}


