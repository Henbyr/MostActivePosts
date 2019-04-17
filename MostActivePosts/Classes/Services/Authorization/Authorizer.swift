//
//  AuthorizationManager.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

class Authorizer {
    func obtainToken(endpoint: Endpoint, completion: @escaping (Result<OAuthToken, SessionError>) -> Void) {
        if let token = TokenRepository.token() {
            let currentDate = Date()
            
            if currentDate < token.expiresInDate {
                completion(.success(token))
                return
            }
        }
        
        guard let request = endpoint.request else {
            completion(.failure(.initializationFailed))
            return
        }
        
        Session.request(request) { (result: Result<TokenResponse, SessionError>) in
            switch result {
            case .success(let response):
                let token = OAuthToken(response: response)
                TokenRepository.save(token: token)
                
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Nested types
extension Authorizer {
    enum Endpoint {
        case appOnly
        
        private var baseUrl: URL? {
            switch self {
            case .appOnly:
                return URL(string: "https://www.reddit.com/api/v1/access_token")
            }
        }
        
        private var body: Data? {
            switch self {
            case .appOnly:
                let grandType = "https://oauth.reddit.com/grants/installed_client"
                
                let param = "grant_type=\(grandType)&device_id=\(deviceId)"
                return param.data(using: .utf8)
            }
        }
        
        /// Generates and saves device id. The ID should be unique per-device of the app.
        private var deviceId: String {
            if let deviceId = UserDefaults.standard.string(forKey: UserDefaultsKeys.deviceId) {
                return deviceId
            }
            
            let uuidString = UUID().uuidString
            UserDefaults.standard.set(uuidString, forKey: UserDefaultsKeys.deviceId)
            
            return uuidString
        }
        
        private var authHeaderValue: String {
            switch self {
            case .appOnly:
                let clientId = "YUtZb2FCTmVnOHVnZVE6"
                return "Basic \(clientId)"
            }
        }
        
        var request: URLRequest? {
            guard let url = baseUrl else { return nil }
            
            switch self {
            case .appOnly:
                var request = URLRequest(url: url)
                request.setValue(authHeaderValue, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                request.httpBody = body
                
                return request
            }
        }
    }
}
