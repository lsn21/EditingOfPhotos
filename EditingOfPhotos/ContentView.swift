//
//  ContentView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var authMode: AuthMode = .login

    var body: some View {
        VStack {
            if authMode == .login {
                LoginView(authMode: $authMode) // Передаем состояние для смены экрана
            } else {
                RegisterView(authMode: $authMode) // Передаем состояние для смены экрана
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
