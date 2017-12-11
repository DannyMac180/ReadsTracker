//
//  NoteViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 12/10/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteNavigationBar: UINavigationBar!
    
    // MARK: - Constants/Variables
    var currentBook: GoogleBook!
    var savedBook: [Book] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteNavigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
        self.view.backgroundColor = HexColor.hexStringToUIColor(hex: "74B3CE")
        noteNavigationBar.topItem?.title = "\(currentBook.title) Notes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        savedBook = fetchCurrentBook()
        noteTextView.text = savedBook[0].note
    }
    
    // MARK: - Private Functions
    private func getCoreDataStack() -> CoreDataStack {
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
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let managedObjectContext = getCoreDataStack().context
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: managedObjectContext)!
        let savedBook = self.savedBook[0]
        let note = noteTextView.text!
        savedBook.setValue(note, forKey: "note")
        
        do {
            try getCoreDataStack().saveContext()
        } catch {
            print("Save Core Data Failed")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
