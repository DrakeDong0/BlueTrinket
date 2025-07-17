//
//  Login.swift
//  Bluetrinket
//
//  Created by Drake Dong on 2025-06-25.
//

import SwiftUI
import Auth0

struct LoginScreen: View{
    @EnvironmentObject var AuthModel: AuthViewModel
    var body: some View {
        ZStack{
            Color(red: 1.0, green: 0.996, blue: 0.98)
                    .ignoresSafeArea()
            Button("login"){
                AuthModel.login()
            }.background(Color.green)
        }
    }
}

#Preview {
    LoginScreen()
}
