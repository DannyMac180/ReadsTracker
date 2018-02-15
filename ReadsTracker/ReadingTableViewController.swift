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
        
        // Set up tableView design
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundView = UIImageView(image: UIImage(named: "Bookshelf Background"))
        self.navigationController?.navigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Load the books that are saved in Core Data to the View Controllers array
        if let savedBooks = CoreDataClient.loadSavedBooks(category: GoogleBook.Category.reading.rawValue) {
            booksReading = savedBooks
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Private Functions
    func deleteCoreDataOf(book: Book) {
        
        do {
            CoreDataClient.getStack().context.delete(book)
            try CoreDataClient.getStack().saveContext()
            
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
        passedBook = GoogleBook(id: selectedBook.id!, authors: [selectedBook.author!], category: GoogleBook.Category(rawValue: "reading"), cover: selectedBook.cover, pageCount: Int(selectedBook.pageCount), summary: selectedBook.summary, title: selectedBook.title!, rating: Int(selectedBook.rating), pagesCompleted: Int(selectedBook.pagesCompleted))
        
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
