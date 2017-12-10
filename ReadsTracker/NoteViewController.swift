//
//  NoteViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 12/10/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var noteNavigationBar: UINavigationBar!
    
    // MARK: - Constants/Variables
    var currentBook: GoogleBook!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteNavigationBar.barTintColor = HexColor.hexStringToUIColor(hex: "74B3CE")
        self.view.backgroundColor = HexColor.hexStringToUIColor(hex: "74B3CE")
        noteNavigationBar.topItem?.title = "\(currentBook.title) Notes"
    }
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
    }
    
    
    
    
}
