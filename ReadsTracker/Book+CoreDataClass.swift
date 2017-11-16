//
//  Book+CoreDataClass.swift
//  BookTracker
//
//  Created by Daniel McAteer on 11/3/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Book)
public class Book: NSManagedObject {
    convenience init(rating: Int, id: String, category: String?, title: String, author: String, pageCount: Int, cover: String?, summary: String?, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Book", in: context) {
            self.init(entity: ent, insertInto: context)
            self.rating = Int16(rating)
            self.id = id
            self.category = category
            self.title = title
            self.author = author
            self.pageCount = Int16(pageCount)
            self.cover = cover
            self.summary = summary
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
