//
//  Book+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 2/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension Book{
    
    convenience init(title: String, authors: [Author], tags: [BookTag], cover: BookCoverPhoto, pdf: PDF, context: NSManagedObjectContext){
        self.init(context: context)
        self.title = title
        self.authors = NSSet(array: authors)
        self.tags = NSSet(array: tags)
        self.coverPhoto = cover
        self.pdf = pdf
    }
    
    class func BooksAll() -> NSFetchRequest<Book>{
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "notebook = %@", notebook)
        
        
        return fetchRequest
    }
    
    
    //MARK: - Gestion Favoritos
    func addTagFavorite() {
        guard let context = self.managedObjectContext else {return}
        
        if let tag = unicObjectWithValue(Constants.favoriteTag, forEntity: "Tag", forKey: "name", context: context){
            let bookTag = BookTag(name: Constants.favoriteTag, tag: tag as! Tag, context: context)
            bookTag.books = self
        }else{
            let tag = Tag(name: Constants.favoriteTag, context: context)
            let bookTag = BookTag(name: Constants.favoriteTag, tag: tag, context: context)
            bookTag.books = self
        }
        
        saveContext(context: context)
        
    }
    
    func removeTagFavorite() {
        guard let context = self.managedObjectContext else {return}
        let bookTags = self.tags?.allObjects as! [BookTag]
        var tagToDelete: BookTag?
        for tag in bookTags{
            if tag.name == Constants.favoriteTag{
                tagToDelete = tag
            }
        }
        //Favorite is empty
        if let tag = unicObjectWithValue(Constants.favoriteTag, forEntity: "Tag", forKey: "name", context: context){
            let tagCast = tag as! Tag
            if tagCast.bookTags?.count == 1{
                context.delete(tagCast)
            }
        }
        
        guard let tagToDeleteOk = tagToDelete else{return}
        context.delete(tagToDeleteOk)

    }
    
    
    class func bookForSearch(_ text: String) -> NSFetchRequest<Book>{
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        
        let titleBook = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [titleBook]
        
        fetchRequest.predicate = NSPredicate(format: "title contains[c] %@ OR tags.name contains[c] %@ OR authors.fullName contains[c] %@" , argumentArray: [text, text, text])
        
        
        return fetchRequest
    }

    
    
    //MARK: - Utils
    class func bookIsFavorite(book: Book) -> Bool{
        let bookTags = book.tags?.allObjects as! [BookTag]
        for tag in bookTags{
            if tag.name == Constants.favoriteTag{
                return true
            }
        }
        return false
    }
    
    

    
}
