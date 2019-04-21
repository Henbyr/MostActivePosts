//
//  TokenRepository.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/17/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

class TokenRepository {
    class func save(token: OAuthToken) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(token), forKey: UserDefaultsKeys.oauthToken)
    }
    
    class func token() -> OAuthToken? {
        guard let tokenData = UserDefaults.standard.value(forKey: UserDefaultsKeys.oauthToken) as? Data else {
            return nil
        }
        
        return try? PropertyListDecoder().decode(OAuthToken.self, from: tokenData)
    }
}
