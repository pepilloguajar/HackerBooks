//
//  Books.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 22/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import UIKit

typealias Author = String
typealias Tag = String

class Book {
    
    //MARK: - Stored properties
    let title : String
    let authors : [Author]
    let tags : [Tag]
    let urlBookCover : URL
    let urlBookPDF : URL

    //MARK: - computed properties
    var authorsName : String {
        get{
            return authors.joined(separator: ",")
        }
    }
    
    var tagsName : String {
        get{
            return tags.joined(separator: ",")
        }
    }
    
    
    //MARK: - Inicializadores
    init(title : String, authors : [Author], tags : [Tag], urlBookCover: URL, urlBookPDF : URL) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.urlBookCover = urlBookCover
        self.urlBookPDF = urlBookPDF
      
    }
    
    
    //MARK: - Proxies
    func proxyForEquality() -> String {
        return "\(title)\(authorsName)\(tagsName)\(urlBookCover)\(urlBookPDF)"
    }
    
    
    
    
}


//MARK: - Protocols

extension Book : Equatable{
    
    public static func ==(lhs: Book, rhs: Book) -> Bool{
        return (lhs.proxyForEquality() == rhs.proxyForEquality())
    }
    
}


extension Book : Comparable{
    
    public static func <(lhs: Book, rhs: Book) -> Bool{
        return (lhs.title < rhs.title)
    }
    
}


extension Book : CustomStringConvertible{
    
    public var description: String {
        get{
            return "\(type(of:self)) - \(title) -- Authors: \(authorsName)"
        }
    }
    
}


















