//
//  PostTableViewCell.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/20/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func thumbnailDidTap(at cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    
    var isPictureShown: Bool {
        return pictureImageView.image != nil
    }
    
    weak var delegate: PostTableViewCellDelegate?
    
    func configure(with post: Post) {
        if let urlString = post.thumbnailUrl {
            thumbnailImageView.cacheImage(urlString: urlString)
            thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbnailTapHandler)))
        }
        
        timeLabel.text = "Posted by \(post.author ?? "_") \(post.postedTimeAgo)"
        titleLabel.text = post.title
        commentsLabel.text = "\(post.totalComments) Comments"
        
        if isPictureShown {
            hidePicture()
        }
    }
    
    @objc private func thumbnailTapHandler(sender: UITapGestureRecognizer? = nil) {
        delegate?.thumbnailDidTap(at: self)
    }
    
    func showPicture(by urlString: String) {
        pictureImageView.cacheImage(urlString: urlString)
    }
    
    func hidePicture() {
        pictureImageView.image = nil
    }
}
