//
//  ReadingTableViewController.swift
//  ReadsTracker
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundView = UIImageView(image: UIImage(named: "Bookshelf Background"))
        self.navigationController?.navigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
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
    
    func deleteCoreDataOf(book: Book) {
        
        do {
            getCoreDataStack().context.delete(book)
            try getCoreDataStack().saveContext()
            
        } catch {
            print("Deleting book failed")
        }
    }
    
    func removeBookFromTableView(indexPath: IndexPath) {
        tableView.beginUpdates()
        booksReading.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksReading.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        cell.updateUI()
        
        let currentBook = booksReading[indexPath.row]
        cell.authorLabel.text = "by \(currentBook.author!)"
        cell.titleLabel?.text = currentBook.title
        cell.bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        
        let selectedBook = booksReading[indexPath.row]
        passedBook = GoogleBook(id: selectedBook.id!, authors: [selectedBook.author!], category: GoogleBook.Category(rawValue: "reading"), cover: selectedBook.cover, pageCount: Int(selectedBook.pageCount), summary: selectedBook.summary, title: selectedBook.title!, rating: Int(selectedBook.rating))
        
        detailController.currentBook = passedBook
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCoreDataOf(book: booksReading[indexPath.row])
            removeBookFromTableView(indexPath: indexPath)
        }
    }
}
