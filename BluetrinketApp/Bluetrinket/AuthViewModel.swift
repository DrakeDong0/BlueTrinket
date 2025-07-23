import Foundation
import Auth0

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    func login() {
        Auth0
            .webAuth(clientId: authData.clientID, domain: authData.domain)
            .redirectURL(URL(string: authData.redirectURL)!)
            .parameters(["prompt": "login"]) // Remove after, this forces login everytime
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                    Task {
                        do {
                            let isNewUser = try await self.backendAuth(with: credentials.accessToken)
                            print(isNewUser ? "New user": "Existing user")
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                            }
                        } catch {
                            print("Failed to login \(error)")
                        }
                    }
                case .failure(let error):
                    print("Login failed: \(error)")
                }
            }
    }
    func logout() {
            Auth0
                .webAuth(clientId: authData.clientID, domain: authData.domain)
                .clearSession { result in
                    switch result {
                    case .success:
                        self.isAuthenticated = false
                    case .failure(let error):
                        print("Logout failed with: \(error)")
                    }
                }
        }
    
    
    func backendAuth(with accessToken: String) async throws -> Bool {
        print("calling backend...")
        guard let url = URL(string: "http://localhost:8010/auth/login") else {
            return false
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let isNewUser = json["isNewUser"] as? Bool {
            return isNewUser
        }
        return false
    }

}
