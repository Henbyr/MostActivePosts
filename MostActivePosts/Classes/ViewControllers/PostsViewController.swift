//
//  PostsViewController.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/18/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

protocol PostsViewProtocol: class {
}

class PostsViewController: UITableViewController, PostsViewProtocol {
    var presenter: PostsPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.obtainNewPosts()
    }
}
