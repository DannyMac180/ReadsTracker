//
//  SearchBooksTableViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import SDWebImage

class SearchBooksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var bookSearchResults = [GoogleBook]()
    let searchController = UISearchController(searchResultsController: nil)
    let googleBooksClient = GoogleBooksClient()
    var passedBook: GoogleBook!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showBookDetail" {
            
            let viewController = segue.destination as! BookDetailViewController
            
            viewController.currentBook = passedBook
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
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        
        let currentBook = bookSearchResults[indexPath.row]
        
        cell.authorLabel.text = currentBook.authors[0]
        cell.titleLabel?.text = currentBook.title
        cell.bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passedBook = bookSearchResults[indexPath.row]
        performSegue(withIdentifier: "showBookDetail", sender: self)
        
    }
}

// MARK: - Extensions

extension SearchBooksTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        if let formattedTerm = formatSearch(withText: searchController.searchBar.text!) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
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
}

extension SearchBooksTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let formattedTerm = formatSearch(withText: searchBar.text) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
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
        if let formattedTerm = formatSearch(withText: searchText) {
            googleBooksClient.searchBooks(query: formattedTerm) { (books) in
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
}
