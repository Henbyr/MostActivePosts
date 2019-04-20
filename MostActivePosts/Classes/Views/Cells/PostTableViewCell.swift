//
//  PostTableViewCell.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/20/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    func configure(with post: Post) {
        timeLabel.text = "Posted by \(post.author ?? "_") \(post.postedTimeAgo)"
        titleLabel.text = post.title
        commentsLabel.text = "\(post.totalComments) Comments"
    }
}
