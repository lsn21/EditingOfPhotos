//
//  AuthViewModel.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var alertMessage: AlertMessage?
    @Published var isUserLoggedIn: Bool = false

    func isLogin() -> Bool {
        var login = false
        if (UserDefaults.standard.object(forKey: "isUserLoggedIn") != nil) {
            login = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        }
        return login
    }

    func signIn() {
    }


    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                self?.alertMessage = AlertMessage(typeAlert: .error, title: "Ошибка", message: error.localizedDescription)
            }
            else {
                self?.isUserLoggedIn = true
                UserDefaults.standard.setValue(self?.isUserLoggedIn, forKey: "isUserLoggedIn")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                self?.alertMessage = AlertMessage(typeAlert: .error, title: "Ошибка", message: error.localizedDescription)
            }
            else {
                self?.sendVerificationEmail()
            }
        }
    }
    
    func sendVerificationEmail() {
        guard let user = Auth.auth().currentUser else { return }
        user.sendEmailVerification { [weak self] (error) in
            if let error = error {
                self?.alertMessage = AlertMessage(typeAlert: .error, title: "Ошибка", message: error.localizedDescription)
            }
            else {
                self?.alertMessage = AlertMessage(typeAlert: .verification, title: "Внимание", message: "На: \(self?.email ?? "") отправлено письмо для подтверждения вашего почтового адреса.")
            }
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if let error = error {
                self?.alertMessage = AlertMessage(typeAlert: .error, title: "Ошибка", message: error.localizedDescription)
            }
            else {
                self?.alertMessage = AlertMessage(typeAlert: .reset, title: "Внимание", message: "Проверьте вашу почту для получения инструкции по сбросу пароля.")
            }
            
        }
    }
}
