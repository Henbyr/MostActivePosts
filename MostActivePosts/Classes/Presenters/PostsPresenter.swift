//
//  PostsPresenter.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

protocol PostsPresenterProtocol: class {
    init(view: PostsViewProtocol, model: PostsModelProtocol)
}

class PostsPresenter: PostsPresenterProtocol {
    private unowned var view: PostsViewProtocol
    private let model: PostsModelProtocol
    
    required init(view: PostsViewProtocol, model: PostsModelProtocol) {
        self.view = view
        self.model = model
    }
}
