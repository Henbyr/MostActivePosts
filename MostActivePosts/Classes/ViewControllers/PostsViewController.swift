//
//  PostsViewController.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/18/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit
import CoreData

protocol PostsViewProtocol: class {
}

class PostsViewController: UITableViewController, PostsViewProtocol {
    var presenter: PostsPresenterProtocol!
    var coreDataStack: CoreDataStack!
    
    private let postCellIdentifier = "PostCell"
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Post> = {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.fetchLimit = 25
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "likes", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreDataStack.managedContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    private var isFetchingNextPage: Bool = false
    
    override func viewDidLoad() {
        tableView.prefetchDataSource = self
        
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.obtainNewPosts()
    }
    
    private func fetchPosts() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error: \(error). Could not fetch records.")
        }
    }
}

extension PostsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellIdentifier, for: indexPath)
        let post = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "\(post.likes): \(post.title!)"
        
        return cell
    }
}

extension PostsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        isFetchingNextPage = false
    }
}

extension PostsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let count = fetchedResultsController.fetchedObjects?.count {
            if !isFetchingNextPage && indexPaths.contains(where: { $0.row == count - 1 }) {
                isFetchingNextPage = true
                presenter.obtainNewPosts()
            }
        }
    }
}
