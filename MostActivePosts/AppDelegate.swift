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
        
        let service = ListingService()
        service.fetch(endpoint: .top(before: nil, after: nil)) { (result: Result<ListingResponse, SessionError>) in
            
        }
        
        return true
    }

}

