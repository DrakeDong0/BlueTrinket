//
//  Login.swift
//  Bluetrinket
//
//  Created by Drake Dong on 2025-06-25.
//

import SwiftUI
import Auth0

struct LoginScreen: View{
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        ZStack{
            Color(red: 1.0, green: 0.996, blue: 0.98)
                    .ignoresSafeArea()
            Button("login"){
                login()
            }.background(Color.green)
        }
    }
    
    func login() {
        Auth0
            .webAuth(clientId: "cdu0WLFF6BVfgKUBVRQw7K6eIo8q9YOD", domain: "dev-oxiw8y8jzhq1qfel.us.auth0.com")
            .redirectURL(URL(string: "com.drakedong.Bluetrinket://com.drakedong.Bluetrinket/callback")!)

            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

#Preview {
    LoginScreen()
}
