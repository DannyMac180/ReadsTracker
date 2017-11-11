//
//  OnboardingViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 11/10/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = 10
        getStartedButton.clipsToBounds = true
    }
    
    @IBAction func getStartedAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstUse")
        performSegue(withIdentifier: "onboard", sender: self)
    }
}
