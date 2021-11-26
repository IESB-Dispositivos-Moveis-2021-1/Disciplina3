//
//  AppNavigation.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import SwiftUI

public enum AppNavigation {
    
    private static let kProviderDetails = ProviderDetails(
        authUrl: "https://994d-2804-d59-a4b2-3b00-c8be-3e33-f6f7-2dac.sa.ngrok.io/auth/realms/IESB/protocol/openid-connect/auth",
        tokenUrl: "https://994d-2804-d59-a4b2-3b00-c8be-3e33-f6f7-2dac.sa.ngrok.io/auth/realms/IESB/protocol/openid-connect/token",
        clientId: "hello-auth",
        redirectUri: "br.pedroh.HelloAuth://oauth",
        responseType: "code",
        scope: "openid"
    )
    
    public static var composeApp: some View {
        return NavigationView {
            LoginView(viewModel: LoginViewModel(with: kProviderDetails))
        }
        .environmentObject(NotificationViewModel.shared)
    }
    
}
