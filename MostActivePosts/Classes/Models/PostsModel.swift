//
//  PostsModel.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import CoreData

protocol PostsModelProtocol: class {
    init(listingService: PostsServiceProtocol, coreDataStack: CoreDataStack)
    
    func fetchPosts()
}

class PostsModel: PostsModelProtocol {
    private let service: PostsServiceProtocol
    private let coreDataStack: CoreDataStack
    
    private var afterPost: String?
    
    required init(listingService: PostsServiceProtocol, coreDataStack: CoreDataStack) {
        self.service = listingService
        self.coreDataStack = coreDataStack
    }
    
    func fetchPosts() {
        service.fetch(endpoint: .top(before: nil, after: afterPost)) { (result: Result<ListingResponse, SessionError>) in
            switch result {
            case .success(let listingResponse):
                let syncContext = self.coreDataStack.storeContainer.newBackgroundContext()
                syncContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                syncContext.undoManager = nil
                
                self.syncPosts(listingData: listingResponse.data, syncContext: syncContext)
                self.afterPost = listingResponse.data.after
            case .failure(let error):
                break
            }
        }
    }
    
    private func syncPosts(listingData: ListingData, syncContext: NSManagedObjectContext) {
        // Delete old records and merge changes to default context
        merge(listingData: listingData, using: syncContext)
        // Create new records.
        save(listingData: listingData, to: syncContext)
    }
    
    private func merge(listingData: ListingData, using syncContext: NSManagedObjectContext) {
        let postTitles = listingData.children.map { $0.data.title }.compactMap { $0 }
        
        let matchingPostRequest: NSFetchRequest<NSFetchRequestResult> = Post.fetchRequest()
        matchingPostRequest.predicate = NSPredicate(format: "title in %@", argumentArray: [postTitles])
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingPostRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // Request to do batch request to delete and merge the changes in to default context
        do {
            let batchDeleteResult = try syncContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                    into: [self.coreDataStack.managedContext])
            }
        } catch {
            print("Error: \(error). Could not batch delete existing records.")
            return
        }
    }
    
    private func save(listingData: ListingData, to syncContext: NSManagedObjectContext) {
        _ = listingData.children.compactMap { self.createPost(from: $0.data, into: syncContext) }
        
        if syncContext.hasChanges {
            do {
                try syncContext.save()
            } catch {
                print("Error: \(error). Could not save Core Data context.")
            }
            syncContext.reset()
        }
    }
    
    private func createPost(from listingChildData: ListingChildData, into syncContext: NSManagedObjectContext) -> NSManagedObject? {
        guard let createdPost = NSEntityDescription.insertNewObject(forEntityName: "Post", into: syncContext) as? Post else {
            return nil
        }
        createdPost.update(listingChildData: listingChildData)
        
        return createdPost
    }
}
