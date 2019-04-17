//
//  AuthorizationManager.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
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

enum AuthorizerError: Error {
    case notInitialized
    case endpoint(error: Error)
}

class Authorizer {
    
    private let authData = AuthData()
    
    func obtainToken(completion: @escaping (Result<OAuthToken, AuthorizerError>) -> Void) {
        if let token = TokenRepository.token() {
            let currentDate = Date()
            
            if currentDate < token.expiresInDate {
                completion(.success(token))
            }
        }
        
        guard let request = authData.request else {
            completion(.failure(.notInitialized))
            return
        }
        
        Session.request(request) { (result: Result<TokenResponse, SessionError>) in
            switch result {
            case .success(let response):
                let token = OAuthToken(response: response)
                TokenRepository.save(token: token)
                
                completion(.success(token))
            case .failure(let error):
                completion(.failure(.endpoint(error: error)))
            }
        }
    }
    
}

private extension Authorizer {
    
    private struct AuthData {
        
        private let authURL = "https://www.reddit.com/api/v1/access_token"
        private let clientId = "YUtZb2FCTmVnOHVnZVE6"
        private let grandType = "https://oauth.reddit.com/grants/installed_client"
        
        /// Generates and saves device id. The ID should be unique per-device of the app.
        private let deviceId: String = {
            if let deviceId = UserDefaults.standard.string(forKey: "deviceId") {
                return deviceId
            }
            
            let uuidString = UUID().uuidString
            UserDefaults.standard.set(uuidString, forKey: "deviceId")
            
            return uuidString
        }()
        
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
