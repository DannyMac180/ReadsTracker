//
//  BookDetailViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class BookDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    // MARK: - Variables/Constants
    
    var currentBook: GoogleBook!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
    }

    // MARK: - Private Functions
    
    @IBAction func toReadButton(_ sender: Any) {
        
        saveCoreData(book: currentBook, category: GoogleBook.Category.toRead)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func readingButton(_ sender: Any) {
        
        saveCoreData(book: currentBook, category: GoogleBook.Category.reading)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishedButton(_ sender: Any) {
        
        saveCoreData(book: currentBook, category: GoogleBook.Category.finished)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getCoreDataStack() -> CoreDataStack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.stack
    }
    
    func setUpViews() {
        
        authorLabel.text = currentBook.authors[0]
        titleLabel.text = currentBook.title
        summaryTextView.text = currentBook.summary
        bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        if let pageCount = currentBook.pageCount {
            pageCountLabel.text = "\(String(describing: pageCount)) pages"
        } else {
            pageCountLabel.text = "Page Count N/A"
        }
    }
    
    func saveCoreData(book: GoogleBook, category: GoogleBook.Category) {
        
        let managedObjectContext = getCoreDataStack().context
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedObjectContext)!
        let savedBook = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Book
        savedBook.setValue(book.authors[0], forKey: "author")
        savedBook.setValue(book.title, forKey: "title")
        savedBook.setValue(category.rawValue, forKey: "category")
        savedBook.setValue(book.pageCount, forKey: "pageCount")
        savedBook.setValue(book.summary, forKey: "summary")
        savedBook.setValue(book.cover, forKey: "cover")
        
        do {
            try getCoreDataStack().saveContext()
            
        } catch {
            print("Add Core Data Failed")
        }
    }
    
    
}

