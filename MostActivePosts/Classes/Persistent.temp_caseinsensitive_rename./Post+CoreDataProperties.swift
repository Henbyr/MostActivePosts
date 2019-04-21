//
//  Post+CoreDataProperties.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/21/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var author: String?
    @NSManaged public var entryDate: NSDate?
    @NSManaged public var imageUrl: String?
    @NSManaged public var likes: Int32
    @NSManaged public var postHint: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var totalComments: Int32
    @NSManaged public var score: Int32

}
