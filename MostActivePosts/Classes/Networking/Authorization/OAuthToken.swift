//
//  OAuthToken.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/17/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

struct OAuthToken: Codable {
    var accessToken: String
    var expiresInDate: Date
    
    init(response: TokenResponse) {
        self.accessToken = response.accessToken
        self.expiresInDate = Date(timeIntervalSinceNow: response.expiresIn)
    }
}
