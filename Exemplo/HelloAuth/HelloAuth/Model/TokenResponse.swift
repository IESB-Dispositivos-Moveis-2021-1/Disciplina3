//
//  TokenResponse.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import Foundation


struct TokenResponse: Codable {
    
    let accessToken: String
    let expiresIn, refreshExpiresIn: Int
    let refreshToken, tokenType, idToken: String
    let notBeforePolicy: Int
    let sessionState, scope: String
    
    var tokenForRequests: String { //informar esse dado no header 'Authorization'
        return "\(tokenType) \(accessToken)"
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case idToken = "id_token"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
    
}
