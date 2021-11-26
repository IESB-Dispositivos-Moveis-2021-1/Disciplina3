//
//  LoginView.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @ObservedObject
    var viewModel: LoginViewModel
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    var body: some View {
        VStack(alignment: .center) {
            
            if viewModel.loading {
                ProgressView()
            }else {
                if let token = viewModel.accessToken {
                    if let credential = viewModel.appleCredential {
                        Text("Usuário logado com Apple: \(token.body["email"] as! String)")
                    }else {
                        Text("Usuário logado: \(token.body["name"] as! String)")
                    }
                }
                Button("Entrar com OAuth 2") {
                    viewModel.doLogin()
                }
            }
            SignInWithAppleButton(.continue,
                                  onRequest: viewModel.setupAppleSignInRequest(_:),
                                  onCompletion: viewModel.appleSignInHandler(_:))
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .fixedSize()
                .opacity(viewModel.loading ? 0 : 1)
            
        }
        .navigationTitle("Hello")
        .navigationBarItems(trailing: NavigationLink("+", destination: {
            NotificationView()
        }))
    }
}
