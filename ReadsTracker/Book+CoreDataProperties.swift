//
//  Book+CoreDataProperties.swift
//  
//
//  Created by Daniel McAteer on 12/10/17.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var cover: String?
    @NSManaged public var id: String?
    @NSManaged public var pageCount: Int16
    @NSManaged public var rating: Int16
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var note: String?

}
