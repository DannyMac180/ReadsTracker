//
//  GoogleBook.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

class GoogleBook {
    let id: String
    let authors: [String]
    var category: Category?
    let cover: String?
    let pageCount: Int?
    let summary: String?
    let title: String
    var rating: Int
    
    enum  Category: String {
        case toRead
        case reading
        case finished
        case none
    }
    
    init(id: String, authors: [String], category: Category?, cover: String?, pageCount: Int?, summary: String?, title: String, rating: Int) {
        self.id = id
        self.authors = authors
        self.category = category
        self.cover = cover
        self.pageCount = pageCount
        self.summary = summary
        self.title = title
        self.rating = rating
    }
}
