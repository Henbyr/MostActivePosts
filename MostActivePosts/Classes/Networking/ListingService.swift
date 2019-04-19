//
//  ListingService.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/17/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

enum PostsServiceEndPoint {
    case top(before: String?, after: String?)
    
    private var baseUrl: URL? {
        return URL(string: "https://oauth.reddit.com")
    }
    
    private var endpointUrl: URL? {
        guard var url = baseUrl else { return nil }
        
        switch self {
        case .top(let before, let after):
            url.appendPathComponent("top")
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [
                URLQueryItem(name: "limit", value: "50"),
                URLQueryItem(name: "count", value: "50")
            ]
            
            if let _ = before {
                components?.queryItems?.append(URLQueryItem(name: "before", value: before))
            }
            if let _ = after {
                components?.queryItems?.append(URLQueryItem(name: "after", value: after))
            }
            
            return components?.url
        }
        
    }
    
    var request: URLRequest? {
        switch self {
        case .top:
            guard let endpointUrl = endpointUrl else { return nil }
            
            var request = URLRequest(url: endpointUrl)
            request.httpMethod = "GET"
            request.setValue("ios:com.example.mostactiveposts:v1.0.0 (by /u/e_oneg1n)", forHTTPHeaderField: "User-Agent")
            
            return request
        }
    }
}

protocol PostsServiceProtocol {
    init(authorizer: Authorizer)
    
    func fetch(endpoint: PostsServiceEndPoint, completion: @escaping (Result<ListingResponse, SessionError>) -> Void)
}

class ListingService: PostsServiceProtocol {
    private let authorizer: Authorizer
    
    required init(authorizer: Authorizer) {
        self.authorizer = authorizer
    }
    
    func fetch(endpoint: PostsServiceEndPoint, completion: @escaping (Result<ListingResponse, SessionError>) -> Void) {
        authorizer.obtainToken(endpoint: .appOnly) { result in
            switch result {
            case .success(let token):
                guard var request = endpoint.request else {
                    completion(.failure(.initializationFailed))
                    return
                }
                request.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
                
                Session.request(request, completion: { (result: Result<ListingResponse, SessionError>) in
                    switch result {
                    case .success(let listing):
                        completion(.success(listing))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
