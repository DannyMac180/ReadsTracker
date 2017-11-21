//
//  WebViewViewController.swift
//  BookTracker
//
//  Created by Daniel McAteer on 11/18/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit
import WebKit

// Todo: Set intial web page to the web page for the book using amazon affiliate marketing

class WebViewViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
    // MARK: - Constants and Variables
    var webView: WKWebView
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var webViewNavigationBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Actions
    @IBAction func back(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        let request = URLRequest(url: webView.url!)
        webView.load(request)
    }
    
    // MARK: - Intializers
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: .zero)
        super.init(coder: aDecoder)
        
        self.webView.navigationDelegate = self
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide tabBar
        self.tabBarController?.tabBar.isHidden = true
        
        // Add barView to view
        view.addSubview(barView)
        
        // Add webViewNavigationBar to view
        view.addSubview(webViewNavigationBar)
        
        // Add progressView to view
        view.addSubview(progressView)
        
        // Add webView to main view
        view.addSubview(webView)
        
        // Add constraints to the webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        let webViewTop = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: barView, attribute: .bottom, multiplier: 1, constant: 0)
        let webViewWidth = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let webViewBottm = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: webViewNavigationBar, attribute: .top, multiplier: 1, constant: 0)
        view.addConstraints([webViewTop, webViewWidth, webViewBottm])
        
        // Add observers
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        // Load desired URL
        let urlString = prependUrl(url: "www.appcoda.com")
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        // Disable nav buttons on loading
        backButton.isEnabled = false
        forwardButton.isEnabled = false
    }
    
    // MARK: - Private Functions
    private func prependUrl(url: String) -> String {
        if !url.hasPrefix("https://") && !url.hasPrefix("http://") {
            let prependedUrl = "https://\(url)"
            return prependedUrl
        } else {
            return url
        }
    }
    
    // MARK: - Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        let prependedUrl = prependUrl(url: textField.text!)
        webView.load(URLRequest(url: URL(string: prependedUrl)!))
        return false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Alert.showbasic(title: "Error", message: error.localizedDescription, vc: self)
    }
    
    private func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
}
