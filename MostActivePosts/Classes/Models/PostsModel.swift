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
        _ = response.data.children.compactMap { self.updatePost(response: $0.data) }
        coreDataStack.saveContext()
    }
    
    private func updatePost(response: ListingChildData) -> NSManagedObject? {
        guard let post = takePost(response: response) else { return nil }
        
        post.author = response.author
        post.entryDate = NSDate(timeIntervalSince1970: response.createdUTC) //TODO: check it
        post.imageUrl = response.url
        if response.thumbnail != "self" && response.thumbnail != "default" {
            post.thumbnailUrl = response.thumbnail
        }
        post.totalComments = Int32(response.numComments)
        post.title = response.title
        post.likes = Int32(response.ups)
        
        return post
    }
    
    private func takePost(response: ListingChildData) -> Post? {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Post.title), response.title)
        if let saved = fetchPost(predicate: predicate) {
            return saved
        }
        if let created = NSEntityDescription.insertNewObject(forEntityName: "Post", into: coreDataStack.managedContext) as? Post {
            return created
        }
        return nil
    }
    
    private func fetchPost(predicate: NSPredicate) -> Post? {
        let fetchRequest:NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            if results.count > 0 {
                return results.first!
            }
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        
        return nil
    }
}
