//
//  ReadingTableViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import CoreData

class ReadingTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable/Constants
    
    var googleBooksClient = GoogleBooksClient.sharedInstance()
    var booksReading: [Book] = []
    var passedBook: GoogleBook!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let savedBooks = loadSavedBooksToRead() {
            booksReading = savedBooks
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Private Functions
    
    func loadSavedBooksToRead() -> [Book]? {
        
        do {
            
            let managedObjectContext = getCoreDataStack().context
            
            let booksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            booksFetch.sortDescriptors = []
            booksFetch.predicate = NSPredicate(format: "category == %@", argumentArray: [GoogleBook.Category.reading.rawValue])
            
            do {
                
                booksReading = try managedObjectContext.fetch(booksFetch) as! [Book]
                return booksReading
                
            } catch {
                
                fatalError("Failed to fetch photos: \(error)")
            }
        }
    }
    
    func getCoreDataStack() -> CoreDataStack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.stack
    }
    
    // MARK: - Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksReading.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        
        let currentBook = booksReading[indexPath.row]
        
        cell.authorLabel.text = currentBook.author
        cell.titleLabel?.text = currentBook.title
        cell.bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        let selectedBook = booksReading[indexPath.row]
        
        passedBook = GoogleBook(authors: [selectedBook.author!], category: GoogleBook.Category(rawValue: "reading"), cover: selectedBook.cover, pageCount: Int(selectedBook.pageCount), summary: selectedBook.summary, title: selectedBook.title!)
        
        detailController.currentBook = passedBook
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}

