//
//  Post+CoreDataClass.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject {
    var postedTimeAgo: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: entryDate! as Date, to: Date())
        
        if let hour = components.hour {
            return "\(hour) hour ago"
        }
        if let min = components.minute {
            return "\(min) ago"
        }
        return ""
    }
    
    var imageUrlString: String? {
        guard let hint = postHint, hint == "image" else {
            return nil
        }
        return imageUrl
    }
    
    func update(listingChildData: ListingChildData) {
        self.author = listingChildData.author
        self.entryDate = NSDate(timeIntervalSince1970: listingChildData.createdUTC) //TODO: check it
        self.imageUrl = listingChildData.url
        if listingChildData.thumbnail != "self" && listingChildData.thumbnail != "default" {
            self.thumbnailUrl = listingChildData.thumbnail
        }
        self.totalComments = Int32(listingChildData.numComments)
        self.title = listingChildData.title
        self.likes = Int32(listingChildData.ups)
        self.postHint = listingChildData.postHint
    }
}
