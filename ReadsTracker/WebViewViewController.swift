//
//  WebViewViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 11/18/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Constants and Variables
    var webView: WKWebView
    @IBOutlet weak var barView: UIView!
    
    // MARK: - Intializers
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: .zero)
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        
        // Add webView to main view
        view.addSubview(webView)
        
        // Add constraints to the webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        // Load desired URL
        let url = URL(string: "http://www.appcoda.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}
