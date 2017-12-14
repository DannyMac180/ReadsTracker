//
//  ViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import CoreData

class ToReadTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables/Constants
    var googleBooksClient = GoogleBooksClient.sharedInstance()
    var booksToRead: [Book] = []
    var passedBook: GoogleBook!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up table view design
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundView = UIImageView(image: UIImage(named: "Bookshelf Background"))
        self.navigationController?.navigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set ViewController's array to books saved in Core Data
        if let savedBooks = loadSavedBooksToRead() {
            booksToRead = savedBooks
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Private Functions
    
    func loadSavedBooksToRead() -> [Book]? {
        
        do {
            let managedObjectContext = getCoreDataStack().context
            
            let booksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            booksFetch.sortDescriptors = []
            booksFetch.predicate = NSPredicate(format: "category == %@", argumentArray: [GoogleBook.Category.toRead.rawValue])
            
            do {
                booksToRead = try managedObjectContext.fetch(booksFetch) as! [Book]
                return booksToRead
                
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
    
    // Remove book from Core Data when cell is swiped left on and delete is pressed
    func removeBookFromTableView(indexPath: IndexPath) {
        tableView.beginUpdates()
        booksToRead.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksToRead.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        cell.updateUI()
        
        let currentBook = booksToRead[indexPath.row]
        
        cell.authorLabel.text = "by \(currentBook.author!)"
        cell.titleLabel?.text = currentBook.title
        cell.bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        let selectedBook = booksToRead[indexPath.row]
        
        passedBook = GoogleBook(id: selectedBook.id!, authors: [selectedBook.author!], category: GoogleBook.Category(rawValue: "toRead"), cover: selectedBook.cover, pageCount: Int(selectedBook.pageCount), summary: selectedBook.summary, title: selectedBook.title!, rating: Int(selectedBook.rating))
        detailController.currentBook = passedBook
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCoreDataOf(book: booksToRead[indexPath.row])
            removeBookFromTableView(indexPath: indexPath)
        }
    }
}
