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
                                                    cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    private var isFetchingNextPage: Bool = false
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellIdentifier,
                                                    for: indexPath) as? PostTableViewCell {
            let post = fetchedResultsController.object(at: indexPath)
            
            cell.configure(with: post)
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension PostsViewController: PostTableViewCellDelegate {
    func thumbnailDidTap(at cell: PostTableViewCell) {
        if let cellIndexPath = tableView.indexPath(for: cell) {
            
            if cell.isPictureShown {
                cell.hidePicture()
            } else {
                let post = fetchedResultsController.object(at: cellIndexPath)
                if let postPictureUrlString = post.imageUrlString {
                    cell.showPicture(by: postPictureUrlString)
                }
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func pictureDidTap(at cell: PostTableViewCell) {
        UIImageWriteToSavedPhotosAlbum(cell.pictureImageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Save error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved",
                                                    message: "This post's picture has been saved to your photos.",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
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
