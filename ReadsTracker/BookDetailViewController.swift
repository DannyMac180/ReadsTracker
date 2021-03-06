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
import WebKit

class BookDetailViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var toReadButton: UIButton!
    @IBOutlet weak var readingButton: UIButton!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var starRating: RatingControl!
    @IBOutlet weak var progressSlider: UISlider!
    
    // MARK: - Variables/Constants
    var currentBook: GoogleBook!
    var savedBooks: [Book] = []
    var toRead = "toRead"
    var reading = "reading"
    var finished = "finished"
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let books = loadSavedBooks() {
            savedBooks = books
        }
        
        self.tabBarController?.tabBar.isHidden = false
        hideCurrentCategory()
        setUpViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        summaryTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Fetch the current book and save it to the view array.
        let savedBooksArray = fetchCurrentBook()
        
        if !savedBooksArray.isEmpty {
            let savedBook = savedBooksArray[0]
            savedBook.setValue(starRating.rating, forKey: "rating")
            savedBook.setValue(Int(progressSlider.value), forKey: "pagesCompleted")
        }
    }
    
    // MARK: - Private Functions
    
    @IBAction func toReadAction(_ sender: Any) {
        setCategory(toRead)
        self.navigationController?.popToRootViewController(animated: true)
        let toReadIndex = 0
        self.tabBarController?.selectedIndex = toReadIndex
    }
    
    @IBAction func readingAction(_ sender: Any) {
        setCategory(reading)
        self.navigationController?.popToRootViewController(animated: true)
        let readingIndex = 1
        self.tabBarController?.selectedIndex = readingIndex
    }
    
    @IBAction func finishedAction(_ sender: Any) {
        setCategory(finished)
        self.navigationController?.popToRootViewController(animated: true)
        let finishedIndex = 2
        self.tabBarController?.selectedIndex = finishedIndex
    }
    
    @objc func shoppingTapped() {
        performSegue(withIdentifier: "shopping", sender: self)
    }
    
    @objc func noteTapped() {
        performSegue(withIdentifier: "showNote", sender: self)
    }
    
    func getCoreDataStack() -> CoreDataStack {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.stack
    }
    
    func fetchCurrentBook() -> [Book] {
        let managedObjectContext = getCoreDataStack().context
        
        let currentBookFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        currentBookFetch.sortDescriptors = []
        currentBookFetch.predicate = NSPredicate(format: "id == %@", argumentArray: [currentBook.id])
        
        do {
            let savedBookArray = try managedObjectContext.fetch(currentBookFetch) as! [Book]
            return savedBookArray
        } catch {
            fatalError("Failed to fetch book: \(error)")
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
    
    func setCategory(_ category: String) {
        if currentBookIsSaved() {
            update(category: category)
            update(rating: starRating.rating)
            update(pagesCompleted: Int(progressSlider.value))
        } else {
            currentBook.rating = starRating.rating
            saveCoreData(book: currentBook, category: GoogleBook.Category(rawValue: category)!)
        }
    }
    
    func currentBookIsSaved() -> Bool {
        for book in savedBooks {
            if currentBook.id == book.id {
                return true
            }
        }
        return false
    }
    
    func update(category: String) {
        let savedBooksArray = fetchCurrentBook()
        
        if !savedBooksArray.isEmpty {
            let savedBook = savedBooksArray[0]
            savedBook.setValue(category, forKey: "category")
            
            do {
                try getCoreDataStack().context.save()
            } catch {
                Alert.showbasic(title: "OK", message: "Couldn't save new category", vc: self)
            }
        }
    }
    
    func update(rating: Int) {
        let savedBooksArray = fetchCurrentBook()
        
        if !savedBooksArray.isEmpty {
            let savedBook = savedBooksArray[0]
            savedBook.setValue(rating, forKey: "rating")
            
            do {
                try getCoreDataStack().context.save()
            } catch {
                Alert.showbasic(title: "OK", message: "Couldn't save new category", vc: self)
            }
        }
    }
    
    func update(pagesCompleted: Int) {
        let savedBooksArray = fetchCurrentBook()
        
        if !savedBooksArray.isEmpty {
            let savedBook = savedBooksArray[0]
            savedBook.setValue(pagesCompleted, forKey: "pagesCompleted")
            
            do {
                try getCoreDataStack().context.save()
            } catch {
                Alert.showbasic(title: "OK", message: "Couldn't save new category", vc: self)
            }
        }
    }
    
    func setUpViews() {
        let shoppingButton = UIBarButtonItem(image: UIImage(named: "shoppingCart"), style: .plain, target: self, action: #selector(shoppingTapped))
        let noteButton = UIBarButtonItem(image: UIImage(named: "note"), style: .plain, target: self, action: #selector(noteTapped))
        self.navigationItem.rightBarButtonItems = [shoppingButton, noteButton]
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper")!)
        
        if !currentBookIsSaved() {
            noteButton.isEnabled = false
        } else {
            noteButton.isEnabled = true
        }
        
        authorLabel.text = "by \(currentBook.authors[0])"
        titleLabel.text = currentBook.title
        summaryTextView.text = currentBook.summary
        bookImageView.sd_setImage(with: URL(string: currentBook.cover!))
        starRating.rating = currentBook.rating
        summaryTextView.backgroundColor = UIColor.clear
        
        if let pageCount = currentBook.pageCount {
            pageCountLabel.text = "\(currentBook.pagesCompleted) / \(pageCount) Pages Completed"
            progressSlider.maximumValue = Float(pageCount)
            progressSlider.setValue(Float(currentBook.pagesCompleted), animated: true)
        } else {
            pageCountLabel.text = "Page Count N/A"
        }
        
        setUpFonts()
    }
    
    func setUpFonts() {
        titleLabel.font = UIFont(name: "GillSans", size: 25.0)
        authorLabel.font = UIFont(name: "GillSans", size: 23.0)
        pageCountLabel.font = UIFont(name: "GillSans", size: 20.0)
        summaryTextView.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
    }
    
    func saveCoreData(book: GoogleBook, category: GoogleBook.Category) {
        let managedObjectContext = getCoreDataStack().context
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedObjectContext)!
        let savedBook = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Book
        savedBook.setValue(book.id, forKey: "id")
        savedBook.setValue(book.authors[0], forKey: "author")
        savedBook.setValue(book.title, forKey: "title")
        savedBook.setValue(category.rawValue, forKey: "category")
        savedBook.setValue(book.pageCount, forKey: "pageCount")
        savedBook.setValue(book.summary, forKey: "summary")
        savedBook.setValue(book.cover, forKey: "cover")
        savedBook.setValue(book.rating, forKey: "rating")
        savedBook.setValue(Int(progressSlider.value), forKey: "pagesCompleted")
        
        do {
            try getCoreDataStack().saveContext()
            
        } catch {
            print("Add Core Data Failed")
        }
    }
    
    func hideCurrentCategory() {
        if let category = currentBook.category?.rawValue {
            switch category {
            case category where category == toRead:
                toReadButton.isEnabled = false
            case category where category == reading:
                readingButton.isEnabled = false
            case category where category == finished:
                finishedButton.isEnabled = false
            default:
                return
            }
        }
    }

    @IBAction func sliderValueChanged(_ sender: Any) {
        currentBook.pagesCompleted = Int(progressSlider.value)
        
        if let pageCount = currentBook.pageCount {
            pageCountLabel.text = "\(currentBook.pagesCompleted) / \(pageCount) Pages Completed"
        }
    }
    
    
    // MARK: - Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopping" {
            let webViewViewController = segue.destination as! WebViewViewController
            let searchSafeTitle = currentBook.title.replacingOccurrences(of: " ", with: "%20")
            webViewViewController.amazonUrlString = "https://www.amazon.com/gp/search?ie=UTF8&tag=mcateerd2-20&linkCode=ur2&linkId=9d074a7a2ae209b3ad868be714042f88&camp=1789&creative=9325&index=books&keywords=\(searchSafeTitle)"
        }
        
        if segue.identifier == "showNote" {
            let noteViewController = segue.destination as! NoteViewController
            noteViewController.currentBook = currentBook
        }
    }
}
