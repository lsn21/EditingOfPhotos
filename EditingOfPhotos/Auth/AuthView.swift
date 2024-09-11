//
//  AuthView.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import SwiftUI
import GoogleSignInSwift

struct AuthView: View {
    @State var isAuth: Bool = true
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var showResetPassword = false
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    @State private var isImagesViewShow = false

    var body: some View {
        
        if !authViewModel.isLogin() {
            VStack(spacing: 20) {
                
                Text(isAuth ? "Авторизация" : "Регистрация")
                    .padding(isAuth ? 16 : 24)
                    .padding(.horizontal, 30)
                    .font(.title2.bold())
                    .background(Color("myWhiteAlpha"))
                    .cornerRadius(isAuth ? 30 : 60)
                    .foregroundColor(Color("myDarkBrown"))
                
                VStack {
                    TextField("Введие email", text: $authViewModel.email)
                        .padding()
                        .background(Color("myWhiteAlpha"))
                        .cornerRadius(12)
                        .padding(8)
                        .padding(.horizontal, 12)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Введие пароль", text: $authViewModel.password)
                        .padding()
                        .background(Color("myWhiteAlpha"))
                        .cornerRadius(12)
                        .padding(8)
                        .padding(.horizontal, 12)
                    
                    if !isAuth {
                        SecureField("Повторите пароль", text: $authViewModel.confirmPassword)
                            .padding()
                            .background(Color("myWhiteAlpha"))
                            .cornerRadius(12)
                            .padding(8)
                            .padding(.horizontal, 12)
                    }
                    Button {
                        if isAuth {
                            authViewModel.login()
                            isImagesViewShow.toggle()
                        }
                        else {
                            let password = $authViewModel.password.wrappedValue
                            let confirmPassword = $authViewModel.confirmPassword.wrappedValue
                            guard password == confirmPassword else {
                                alertMessage = "Пароли не совпадают!"
                                isShowAlert.toggle()
                                return
                            }
                            if password.count < 6 {
                                alertMessage = "Пароль не может быть короче 6 символов!"
                                isShowAlert.toggle()
                                return
                            }
                            authViewModel.register()
                        }
                    }
                label: {
                    Text(isAuth ? "Войти" : "Создать аккаунт")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [Color("myYellow"), Color("myOrange")], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                        .padding(8)
                        .padding(.horizontal, 12)
                        .font(.title3.bold())
                        .foregroundColor(Color("myDarkBrown"))
                }
                    
                    Button {
                        isAuth.toggle()
                    } label: {
                        Text(isAuth ? "Зарегистрироваться" : "Есть аккаунт")
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .padding(8)
                            .padding(.horizontal, 12)
                            .font(.title3.bold())
                            .foregroundColor(Color("myDarkBrown"))
                    }
                    Button("Забыли пароль?") {
                        showResetPassword.toggle()
                    }
                    .sheet(isPresented: $showResetPassword) {
                        ResetPasswordView(viewModel: authViewModel)
                    }
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal), action: authViewModel.signIn)
                        .accessibilityIdentifier("GoogleSignInButton")
                        .accessibility(hint: Text("Sign in with Google button."))
                        .padding()
                }
                .padding()
                .padding(.top, 16)
                .background(Color("myWhiteAlpha"))
                .cornerRadius(24)
                .padding(isAuth ? 30 : 12)
                .alert(item: $authViewModel.alertMessage) { alertMessage in
                    Alert(title: Text(alertMessage.title), message: Text(alertMessage.message), dismissButton: .default(Text("OK")) {
                        if alertMessage.typeAlert == .verification {
                            isAuth.toggle()
                        }
                    })
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("myLiteGray"))
                .animation(Animation.easeInOut(duration: 0.3), value: isAuth)
                .fullScreenCover(isPresented: $isImagesViewShow) {
                    ImagesView()
                }
        }
        else {
            ImagesView()
        }
    }
}

