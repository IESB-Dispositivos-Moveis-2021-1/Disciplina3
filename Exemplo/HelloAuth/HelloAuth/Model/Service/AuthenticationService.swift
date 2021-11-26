//
//  AuthenticationService.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import Foundation
import AuthenticationServices
import JWTDecode
import Combine

class AuthenticationService: NSObject {
    
    typealias AccessTokenCallBack = (_:JWT?, _:Error?) -> Void
    
    
    let providerDetails: ProviderDetails
    let accessTokenCallback: AccessTokenCallBack
    
    init(with providerDetails: ProviderDetails, callback: @escaping AccessTokenCallBack) {
        self.providerDetails = providerDetails
        self.accessTokenCallback = callback
    }
    

    func doLogin() {
        let pd = providerDetails
        let url = URL(string: "\(pd.authUrl)?scope=\(pd.scope)&client_id=\(pd.clientId)&redirect_uri=\(pd.redirectUri)&response_type=\(pd.responseType)")!
        
        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: nil,
            completionHandler: handleAuthorizationCode(_:_:))
        
        session.prefersEphemeralWebBrowserSession = false
        session.presentationContextProvider = self
        
        if session.canStart {
            session.start()
        }
        
    }
    
    private func handleAuthorizationCode(_ callbackUrl: URL?, _ error: Error?) {
        if let queryComponents = callbackUrl?.query?.components(separatedBy: "&"),
           let code = queryComponents.map({URLQueryItem(name: $0.components(separatedBy: "=")[0], value: $0.components(separatedBy: "=")[1])})
            .first(where: {$0.name == "code"})?.value,
           let url = URL(string: providerDetails.tokenUrl) {
            
            let pd = providerDetails
            let params = "code=\(code)&client_id=\(pd.clientId)&redirect_uri=\(pd.redirectUri)&grant_type=authorization_code"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = params.data(using: .utf8)
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .tryMap(extractData(_:_:))
                .decode(type: TokenResponse.self, decoder: JSONDecoder())
                .tryMap(extractToken(_:))
                .eraseToAnyPublisher()
                .subscribe(self)
        }
    }
    
    private func extractData(_ data: Data, _ response: URLResponse) throws -> Data {
        let response = response as! HTTPURLResponse
        if response.statusCode >= 200 && response.statusCode < 300 {
            return data
        }else {
            debugPrint(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
            throw URLError(URLError.Code(rawValue: response.statusCode))
        }
    }
    
    private func extractToken(_ tokenResponse: TokenResponse) throws -> JWT {
        if let jsonData = try? JSONEncoder().encode(tokenResponse) {
            UserDefaults.standard.set(jsonData, forKey: "token")
        }
        return try JWTDecode.decode(jwt: tokenResponse.accessToken)
    }
    
}

extension AuthenticationService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

extension AuthenticationService: Subscriber {
    
    typealias Input = JWT
    typealias Failure = Error
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: JWT) -> Subscribers.Demand {
        accessTokenCallback(input, nil)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error): accessTokenCallback(nil, error)
            case .finished: return
        }
    }
    
    
    
    
    
    
}
