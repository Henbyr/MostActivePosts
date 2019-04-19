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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Post> = {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.fetchLimit = 25
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "likes", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: coreDataStack.managedContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: "MostActivePosts")
        controller.delegate = self
        return controller
    }()
    
    private let postCellIdentifier = "PostCell"
    
    override func viewDidLoad() {
        tableView.prefetchDataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error.localizedDescription)")
        }
        
        presenter.obtainNewPosts()
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
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension PostsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}
