//
//  AuthorizationManager.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

class Authorizer {
    
    private let configuration = Configuration()
    
    func obtainToken(completion: @escaping (Result<TokenResponse, ServiceError>) -> ()) {
        guard let request = configuration.request else { return }
        
        URLSession.shared.dataTask(with: request) { result in
            switch result {
            case .success(let response, let data):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidStatus))
                    return
                }
                do {
                    let values = try JSONDecoder().decode(TokenResponse.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodingFailed))
                }
            case .failure:
                completion(.failure(.tokenFailed))
            }
        }.resume()
    }
    
}

extension Authorizer {
    
    struct Configuration {
        
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
