//
//  SessionError.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

enum SessionError: Error {
    case statusInvalid
    case decodingFailed
    case endpointError(error: Error)
}
