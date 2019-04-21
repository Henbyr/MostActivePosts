//
//  AppDelegate.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "Model")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        assemblePostsViewController()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    private func assemblePostsViewController() {
        if let postsNavigationController = window?.rootViewController as? UINavigationController,
            let postsViewController = postsNavigationController.topViewController as? PostsViewController {
                let service = ListingService(authorizer: Authorizer())
                let model = PostsModel(listingService: service, coreDataStack: coreDataStack)
            
                postsViewController.presenter = PostsPresenter(view: postsViewController, model: model)
                postsViewController.coreDataStack = coreDataStack
        }
    }
}

