//
//  PostsModel.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

protocol PostsModelProtocol {
    init(listingService: PostsServiceProtocol)
}

struct PostsModel: PostsModelProtocol {
    private let service: PostsServiceProtocol
    
    init(listingService: PostsServiceProtocol) {
        self.service = listingService
    }
}
