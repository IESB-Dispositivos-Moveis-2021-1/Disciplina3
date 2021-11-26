//
//  LoginViewModel.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import Foundation
import JWTDecode
import AuthenticationServices

class LoginViewModel: ObservableObject {
    
    private let providerDetails: ProviderDetails
    
    private var service: AuthenticationService?
    
    
    init(with providerDetails: ProviderDetails) {
        self.providerDetails = providerDetails
    }
    
    @Published
    var loading = false
    
    @Published
    var accessToken: JWT? {
        didSet{
            loading = false
        }
    }
    
    @Published
    var appleCredential: ASAuthorizationAppleIDCredential? {
        didSet {
            loading = false
            if let tokenData = appleCredential?.identityToken,
               let token = try? JWTDecode.decode(jwt: String(data: tokenData, encoding: .utf8)!)
            {
                loginCompleted(token, nil)
            }
        }
    }
    
    private func getAuthenticationService() -> AuthenticationService {
        if service == nil {
            service = AuthenticationService(with: providerDetails, callback: loginCompleted(_:_:))
        }
        return service!
    }
    
    
    func doLogin() {
        let service = getAuthenticationService()
        loading = true
        service.doLogin()
    }
    
    private func loginCompleted(_ accessToken: JWT?, _ error: Error?) {
        self.accessToken = accessToken
    }
    
    // MARK - Sign in with Apple
    
    func setupAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
        loading = true
    }
    
    func appleSignInHandler(_ result: Result<ASAuthorization, Error>) {
        switch result {
            case .success(let authResult):
                if let credential = authResult.credential as? ASAuthorizationAppleIDCredential {
                    appleCredential = credential
                }
            case .failure(let error):
                loginCompleted(nil, error)
        }
    }
    
}
