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
typealias Authors = [Author]
typealias Tags = Set<Tag>
typealias Pdf = URL
typealias Image  = URL

class Book {
    
    //MARK: - Stored properties
    let title : String
    let authors : Authors
    var tags : Tags
    let urlBookCover : Image
    let urlBookPDF : Pdf
    
    var urlCoverLocal :Image? = nil
    

    //MARK: - computed properties
    var authorsName : String {
        get{
            return authors.sorted().joined(separator: ", ")
        }
    }
    
    var tagsName : String {
        get{
            return tags.sorted().map({$0.name}).joined(separator: ", ")
        }
    }
    
    
    //MARK: - Inicializadores
    init(title : String, authors : [Author], tags : Tags, urlBookCover: Image, urlBookPDF : Pdf) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.urlBookCover = urlBookCover
        self.urlBookPDF = urlBookPDF
      
    }
    
    //Favorite function
    func addTagFavorite() {
        tags.insert(Tag.favoriteTag)
    }
    
    func removeTagFavorite() {
        tags.remove(Tag.favoriteTag)
    }
    
    func containsFavoriteTag() -> Bool {
        return tags.contains(Tag.favoriteTag)
    }
    
    
    //MARK: - Proxies
    func proxyForEquality() -> String {
        return "\(title)\(authorsName)\(urlBookCover)\(urlBookPDF)"
    }
    
    func proxyForHashable() -> String {
        return "\(title)\(authorsName)"
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

// Para el MapDictionary
extension Book : Hashable{

    public var hashValue: Int {
        get{
            return proxyForEquality().hashValue
        }
    }
    
}


















