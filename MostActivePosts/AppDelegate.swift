//
//  AppDelegate.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/16/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let postsViewController = window?.rootViewController as? PostsViewController {
            let service = ListingService(authorizer: Authorizer())
            let model = PostsModel(listingService: service)
            
            postsViewController.presenter = PostsPresenter(view: postsViewController, model: model)
        }
        
        return true
    }

}

