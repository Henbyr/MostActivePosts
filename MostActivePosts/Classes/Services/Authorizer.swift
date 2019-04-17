//
//  AuthorizationManager.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

class Authorizer {
    
    private let authData = AuthData()
    
    func obtainToken(completion: @escaping (Result<TokenResponse, SessionError>) -> Void) {
        guard let request = authData.request else { return }
        
        Session.request(request, completion: completion)
    }
    
}

extension Authorizer {
    
    struct AuthData {
        
        private let authURL = "https://www.reddit.com/api/v1/access_token"
        private let clientId = "YUtZb2FCTmVnOHVnZVE6"
        private let grandType = "https://oauth.reddit.com/grants/installed_client"
        private let deviceId = "8ab8eb05-1b0f-47d7-bec7-e6396af3967e"
        
        private var basicAuthorizationHeader: String {
            return "Basic \(clientId)"
        }
        
        private var body: Data? {
            let param = "grant_type=\(grandType)&device_id=\(deviceId)"
            return param.data(using: .utf8)
        }
        
        var request: URLRequest? {
            guard let url = URL(string: authURL) else { return nil }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(basicAuthorizationHeader, forHTTPHeaderField: "Authorization")
            request.httpBody = body
            
            return request
        }
        
    }
    
}
