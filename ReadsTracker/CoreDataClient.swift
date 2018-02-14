//
//  CoreDataClient.swift
//  BookTracker
//
//  Created by Daniel McAteer on 2/12/18.
//  Copyright © 2018 Daniel McAteer. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataClient {
    class func getStack() -> CoreDataStack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.stack
    }
    
    class func loadSavedBooks(category: GoogleBook.Category.RawValue) -> [Book]? {
        
        do {
            let managedObjectContext = getStack().context
            
            let booksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            booksFetch.sortDescriptors = []
            booksFetch.predicate = NSPredicate(format: "category == %@", argumentArray: [category])
            
            do {
                let array = try managedObjectContext.fetch(booksFetch) as! [Book]
                return array
                
            } catch {
                fatalError("Failed to fetch photos: \(error)")
            }
        }
    }
}
