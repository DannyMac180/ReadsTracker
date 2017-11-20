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
    @IBOutlet weak var urlTextField: UITextField!
    
    // MARK: - Intializers
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: .zero)
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add barView to view
        view.addSubview(barView)
        
        // Add webView to main view
        view.addSubview(webView)
        
        // Add constraints to the webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        let webViewTop = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: barView, attribute: .bottom, multiplier: 1, constant: 0)
        let webViewWidth = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let webViewBottm = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([webViewTop, webViewWidth, webViewBottm])
        
        // Load desired URL
        let url = URL(string: "http://www.appcoda.com")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    // MARK: - Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        webView.load(URLRequest(url: URL(string: urlTextField.text!)!))
        return false
    }
    
}
