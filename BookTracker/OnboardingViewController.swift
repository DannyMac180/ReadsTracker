//
//  OnboardingViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 11/10/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBAction func getStartedButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isFirstUse")
        performSegue(withIdentifier: "onboard", sender: self)
    }
}
