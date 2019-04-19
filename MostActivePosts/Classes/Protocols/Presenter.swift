//
//  Presenter.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/18/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

import UIKit

protocol View: AnyObject {
}

protocol Presenter {
    init<T: Model, U: View>(view: U, model: T)
}

protocol Model {
}
