//
//  ResetPasswordView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Введие email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            Button("Сбросить пароль") {
                viewModel.resetPassword()
            }
            .alert(item: $viewModel.alertMessage) { alertMessage in
                Alert(title: Text("Внимание"), message: Text(alertMessage.message), dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        .padding()
    }
}
