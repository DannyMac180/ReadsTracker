//
//  CoreDataClient.swift
//  BookTracker
//
//  Created by Daniel McAteer on 2/12/18.
//  Copyright © 2018 Daniel McAteer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataClient {
    func getCoreDataStack() -> CoreDataStack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.stack
    }
    
    func loadSavedBooks(category: GoogleBook.Category.Type, array: [Book]) -> [Book]? {
        
        do {
            let managedObjectContext = getCoreDataStack().context
            
            let booksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            booksFetch.sortDescriptors = []
            booksFetch.predicate = NSPredicate(format: "category == %@", argumentArray: [GoogleBook.Category.toRead.rawValue])
            
            do {
                array = try managedObjectContext.fetch(booksFetch) as! [Book]
                return array
                
            } catch {
                fatalError("Failed to fetch photos: \(error)")
            }
        }
    }
}
