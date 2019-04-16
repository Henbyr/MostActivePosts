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
        
        let authorizer = Authorizer()
        authorizer.obtainToken { result in
            switch result {
            case .success(let token):
                break
            case .failure(let error):
                break
            }
        }
        
        
        return true
    }

}

