//
//  RegisterView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct GoogleSignInButton: View {
    var body: some View {
        Button(action: {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                }
                
                guard let user = result?.user else { return }
                
                // Получаем idToken и accessToken напрямую из user
                let idToken = user.idToken?.tokenString ?? ""
                let accessToken = user.accessToken.tokenString
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase sign-in error: \(error.localizedDescription)")
                    } else {
                        // Успешный вход в Firebase
                    }
                }
            }
        }) {
            Text("Sign in with Google")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}

struct RegisterView: View {
    @Binding var authMode: AuthMode
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            TextField("Email", text: $authViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Register") {
                authViewModel.register()
            }
            .alert(item: $authViewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
            Button(action: {
                authMode = .login // Переключение на вход
            }) {
                Text("Already have an account? Login")
            }
        }
        .padding()
    }
}
