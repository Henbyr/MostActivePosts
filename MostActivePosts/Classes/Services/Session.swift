//
//  URLSession.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case statusInvalid
    case decodingFailed
    case endpointError(error: Error)
}

class Session {
    
    static func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, SessionError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.statusInvalid))
                    return
                }
                do {
                    let values = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodingFailed))
                }
            case .failure(let error):
                completion(.failure(.endpointError(error: error)))
            }
            }.resume()
    }
    
}

extension URLSession {
    
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "Domain", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((response, data)))
        })
    }
    
}
