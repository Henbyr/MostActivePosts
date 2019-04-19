//
//  PostsModel.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import CoreData

protocol PostsModelProtocol {
    init(listingService: PostsServiceProtocol, coreDataStack: CoreDataStack)
    
    func fetchPosts()
}

struct PostsModel: PostsModelProtocol {
    private let service: PostsServiceProtocol
    private let coreDataStack: CoreDataStack
    
    init(listingService: PostsServiceProtocol, coreDataStack: CoreDataStack) {
        self.service = listingService
        self.coreDataStack = coreDataStack
    }
    
    func fetchPosts() {
        service.fetch(endpoint: .top(before: nil, after: nil)) { (result: Result<ListingResponse, SessionError>) in
            switch result {
            case .success(let listingResponse):
                self.saveToContext(response: listingResponse)
            case .failure(let error):
                break
            }
        }
    }
    
    private func saveToContext(response: ListingResponse) {
        _ = response.data.children.compactMap { self.createPost(response: $0.data) }
        coreDataStack.saveContext()
    }
    
    private func createPost(response: ListingChildData) -> NSManagedObject? {
        guard let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: coreDataStack.managedContext) as? Post else {
            return nil
        }
        
        postEntity.author = response.author
        postEntity.entryDate = NSDate(timeIntervalSince1970: response.createdUTC) //TODO: check it
        postEntity.imageUrl = response.url
        if response.thumbnail != "self" && response.thumbnail != "default" {
            postEntity.thumbnailUrl = response.thumbnail
        }
        postEntity.totalComments = Int32(response.numComments)
        postEntity.title = response.title
        
        return postEntity
    }
}
