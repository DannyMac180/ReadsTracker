//
//  OnboardingViewController.swift
//  ReadsTracker
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
        if UserDefaults.standard.bool(forKey: "isFirstUse") == true {
            UserDefaults.standard.set(false, forKey: "isFirstUse")
            performSegue(withIdentifier: "onboard", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
