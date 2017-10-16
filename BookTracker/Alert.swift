//
//  Alert.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/11/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    class func showbasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
