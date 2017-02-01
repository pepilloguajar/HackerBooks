//
//  Library.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 1/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

typealias Books = MultiDictionary<Tag, Book>
typealias TagName = Tag

class Library  {
    
    //MARK: - Properties
    var books : Books
    
    
    
    var tags : [Tag] {
        get{
            return books.keys.sorted()
        }
    }
    
    var tagCount : Int{
        get{
            return tags.count
        }
    }
    
    var bookCount : Int{
        get{
            return books.countUnique
        }
    }
    
    //MARK: - Inicializador
    init(books : [Book]) {
        self.books = Books()
        for book in books {
            for tag in book.tags{
                self.books.insert(value: book, forKey: tag)
            }
        }
    }
    
    
    //MARK: - Accessors
    
    func bookCount(forTagName name : Tag ) -> Int {
        guard let numBook = books[name]?.count else {
            return 0
        }
        return numBook
    }
    
    func books(forTagName name : Tag) -> [Book]? {
        guard let books = self.books[name] else{
            return nil
        }
        return Array(books).sorted()
    }
    
    func book(fotTagName name: Tag, at: Int) -> Book? {
        guard let arrayBook = self.books(forTagName: name) else{
            return nil
        }
        if (arrayBook.count < at && arrayBook.count > 0) {
            return nil
        }
        return arrayBook[at]
    }

    
    
    
    
}
