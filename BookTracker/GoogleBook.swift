//
//  GoogleBook.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation

class GoogleBook {
    
    let authors: [String]
    let category: Category?
    let cover: String?
    let pageCount: Int?
    let summary: String?
    let title: String
    
    enum  Category: String {
        case toRead = "toRead"
        case reading = "reading"
        case finished = "finished"
    }
    
    init(authors: [String], category: Category?, cover: String?, pageCount: Int?, summary: String?, title: String) {
        
        self.authors = authors
        self.category = category
        self.cover = cover
        self.pageCount = pageCount
        self.summary = summary
        self.title = title
    }
}

