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
    func pictureDidTap(at cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var pitcureHeightConstraint: NSLayoutConstraint!
    
    static var cellIdentifier: String {
        return String(describing: self)
    }
    weak var delegate: PostTableViewCellDelegate?
    
    var isPictureShown: Bool {
        return pitcureHeightConstraint.constant != 0
    }
    
    func configure(with post: Post) {
        if let urlString = post.thumbnailUrl {
            thumbnailImageView.cacheImage(urlString: urlString)
            thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(thumbnailTapHandler)))
        }
        
        timeLabel.text = "Posted by \(post.author ?? "_") \(post.postedTimeAgo)"
        titleLabel.text = post.title
        commentsLabel.text = "\(post.totalComments) Comments"
        
        if let urlString = post.imageUrlString {
            pictureImageView.cacheImage(urlString: urlString)
            pictureImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pictureTapHandler)))
        }
        hidePicture()
    }
    
    @objc private func thumbnailTapHandler(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        delegate?.thumbnailDidTap(at: self)
    }
    
    @objc private func pictureTapHandler(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        delegate?.pictureDidTap(at: self)
    }
    
    func showPicture(by urlString: String) {
        pitcureHeightConstraint.constant = 300
    }
    
    func hidePicture() {
        pitcureHeightConstraint.constant = 0
    }
}
