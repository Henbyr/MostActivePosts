//
//  PostsPresenter.swift
//  MostActivePosts
//
//  Created by Eugene Lobyr on 4/19/19.
//  Copyright © 2019 Eugene Lobyr. All rights reserved.
//

protocol PostsPresenterProtocol: class {
    init(view: PostsViewProtocol, model: PostsModelProtocol)
    
    func obtainNewPosts()
}

class PostsPresenter: PostsPresenterProtocol {
    private unowned var view: PostsViewProtocol?
    private var model: PostsModelProtocol
    
    required init(view: PostsViewProtocol, model: PostsModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func obtainNewPosts() {
        model.fetchPosts()
    }
}
