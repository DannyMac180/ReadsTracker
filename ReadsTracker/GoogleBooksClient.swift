//
//  GoogleBooksClient.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import Foundation
import UIKit

class GoogleBooksClient: NSObject {
    
    class func sharedInstance() -> GoogleBooksClient {
        struct Singleton {
            static var sharedInstance = GoogleBooksClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Constants
    
    private static let GoogleBooksAPI = GoogleBooksAPIKey()
    private static let APIKey = GoogleBooksAPI.key
    private static let limit = 30
    
    // MARK: Search Books Function
    
    func searchBooks(query: String, completionHandler: @escaping (_ books: [GoogleBook]?) -> Void) {
        var books: [GoogleBook] = []
        
        // Set up URL components
        var requestComponents = URLComponents()
        requestComponents.scheme = "https"
        requestComponents.host = "www.googleapis.com"
        requestComponents.path = "/books/v1/volumes"
        
        // Set up query items
        let bookQuery = URLQueryItem(name: "q", value: query)
        let apiKey = URLQueryItem(name: "key", value: GoogleBooksClient.APIKey)
        let maxResults = URLQueryItem(name: "maxResults", value: "\(GoogleBooksClient.limit)")
        requestComponents.queryItems = [bookQuery, apiKey, maxResults]
        
        // Set up URL Request
        let request = NSMutableURLRequest(url: requestComponents.url!)
        
        let session = URLSession.shared
        
        // Begin data task using request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let error = error {
                print("Download failed due to error: \(error)")
                let vc = self.getTopViewController()
                DispatchQueue.main.async {
                    Alert.showbasic(title: "Oops!", message: error.localizedDescription, vc: vc)
                }
                return
            }
            
            // If a request is successful, handle results with completionHandler
            if let validData = data {
                books = self.jsonDataToBooks(data: validData)
                completionHandler(books)
            }
        }
        
        task.resume()
    }
    
    // MARK: JSON Parsing Function
    
    func jsonDataToBooks(data: Data) -> [GoogleBook] {
        var books: [GoogleBook] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let results = jsonData as? [String: AnyObject] else {
                print("Error when casting JSON data to [String: AnyObject]")
                return books
            }
            
            guard let bookResults = results["items"] as? [[String: Any]] else {
                print("Error with bookResults")
                return books
            }
            
            for book in bookResults {
                if let volumeInfo = book["volumeInfo"] as? [String: Any],
                    let id = book["id"] as? String,
                    let title = volumeInfo["title"] as? String,
                    let authors = volumeInfo["authors"] as? [String],
                    let pageCount = volumeInfo["pageCount"] as! Int?,
                    let imageDict = volumeInfo["imageLinks"] as? [String: String],
                    let searchInfo = book["searchInfo"] as? [String: Any],
                    var summary = searchInfo["textSnippet"] as! String? {
                    
                    // Transform strings to fix GoogleBooks characters that were broken
                    summary = addParentheses(toSummary: summary)
                    summary = addApostrophe(toSummary: summary)
                    
                    let cover = imageDict["smallThumbnail"]
                    let bookInfo = GoogleBook(id: id, authors: authors, category: nil, cover: cover, pageCount: pageCount, summary: summary, title: title, rating: 0, pagesCompleted: 0)
                    books.append(bookInfo)
                }
            }
            return books
            
        } catch {
            print(error.localizedDescription)
        }
        
        return books
    }
    
    // MARK: - Helper Methods
    func getTopViewController() -> UIViewController {
        
        var viewController = UIViewController()
        
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
            
            viewController = vc
            var presented = vc
            
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        return viewController
    }
    
    func addParentheses(toSummary: String) -> String {
        return toSummary.replacingOccurrences(of: "&quot;", with: "\"")
    }
    
    func addApostrophe(toSummary: String) -> String {
        return toSummary.replacingOccurrences(of: "&#39;", with: "'")
    }
}

