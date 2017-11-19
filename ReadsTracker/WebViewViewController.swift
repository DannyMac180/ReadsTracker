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
    var webView: WKWebView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize webView
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        
        // Add webView to main view
        self.view.addSubview(webView)
        
        // Load desired URL
        let url = URL(string: "http://www.google.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}
