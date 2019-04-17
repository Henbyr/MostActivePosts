//
//  TokenResponse.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

class TokenResponse: Codable {
    
    let accessToken: String
    let tokenType: String
    let deviceId: String
    let expiresIn: Double
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case deviceId = "device_id"
        case expiresIn = "expires_in"
        case scope
    }
    
}
