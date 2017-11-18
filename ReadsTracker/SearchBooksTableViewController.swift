//
//  SearchBooksTableViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class SearchBooksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var bookSearchResults = [GoogleBook]()
    var savedBooks: [Book] = []
    let searchController = UISearchController(searchResultsController: nil)
    let googleBooksClient = GoogleBooksClient()
    var passedBook: GoogleBook!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.navigationController?.navigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
        tableView.backgroundView = UIImageView(image: UIImage(named: "Bookshelf Background"))
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search by title or author"
        searchController.searchBar.autocorrectionType = .yes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let books = loadSavedBooks() {
            savedBooks = books
        }
    }
    
    // MARK: - Private Instance Methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func formatSearch(withText: String?) -> String? {
        if let searchTerm = withText {
            let formattedTerm = searchTerm.replacingOccurrences(of: " ", with: "_")
            return formattedTerm
        } else {
            return nil
        }
    }
    
    func loadSavedBooks() -> [Book]? {
        
        do {
            let managedObjectContext = getCoreDataStack().context
            
            let booksFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
            booksFetch.sortDescriptors = []
            
            do {
                let books = try managedObjectContext.fetch(booksFetch) as! [Book]
                return books
                
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
        return bookSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        cell.updateUI()
        
        let currentBook = bookSearchResults[indexPath.row]
        
        cell.authorLabel.text = "by \(currentBook.authors[0])"
        cell.titleLabel?.text = currentBook.title
        cell.bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "BookDetailViewController") as! BookDetailViewController
        let selectedBook = bookSearchResults[indexPath.row]
        passedBook = selectedBook
        detailController.currentBook = passedBook
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

// MARK: - Extensions
extension SearchBooksTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let formattedTerm = formatSearch(withText: searchController.searchBar.text!) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if let books = books {
                        self.bookSearchResults = books
                        self.tableView.setNeedsLayout()
                        self.tableView.reloadData()
                        }
                    }
                }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

extension SearchBooksTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let formattedTerm = formatSearch(withText: searchBar.text) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                DispatchQueue.main.async {
                    if let books = books {
                        self.bookSearchResults = books
                        self.tableView.setNeedsLayout()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let formattedTerm = formatSearch(withText: searchText) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if let books = books {
                        self.bookSearchResults = books
                        self.tableView.setNeedsLayout()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
