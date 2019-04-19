//
//  PostsModel.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import CoreData

protocol PostsModelProtocol {
    init(listingService: PostsServiceProtocol, managedContext: NSManagedObjectContext)
}

struct PostsModel: PostsModelProtocol {
    private let service: PostsServiceProtocol
    private let managedContext: NSManagedObjectContext
    
    init(listingService: PostsServiceProtocol, managedContext: NSManagedObjectContext) {
        self.service = listingService
        self.managedContext = managedContext
    }
}
