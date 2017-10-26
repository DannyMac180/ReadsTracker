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
    
    private static let APIKey = "AIzaSyB7EcxqkJWvkn0D1RLK3fdO6aUASAxukWU"
    private static let googleBooksURL = "https://www.googleapis.com/books/v1/volumes?"
    private static let limit = 30
    
    // MARK: Book Search Funtion
    
    func searchBooks(query: String, completionHandler: @escaping (_ books: [GoogleBook]?) -> Void) {
        var books: [GoogleBook] = []
        
        let request = NSMutableURLRequest(url: URL(string: "\(GoogleBooksClient.googleBooksURL)q=\(query)&key=\(GoogleBooksClient.APIKey)&maxResults=\(GoogleBooksClient.limit)")!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let error = error {
                print("Download failed due to error: \(error)")
                let vc = self.getTopViewController()
                DispatchQueue.main.async {
                        Alert.showbasic(title: "Oops!", message: error.localizedDescription, vc: vc)
                }
                return
            }
            
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
                    let summary = volumeInfo["description"] as! String? {
                    
                    let cover = imageDict["smallThumbnail"]
                    let bookInfo = GoogleBook(id: id, authors: authors, category: nil, cover: cover, pageCount: pageCount, summary: summary, title: title)
                    books.append(bookInfo)
                }
            }
            return books
            
        } catch {
            print(error)
        }
        
        return books
    }
    
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
}

