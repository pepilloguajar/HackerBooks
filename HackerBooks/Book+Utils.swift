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
    
    
    
    //MARK: - Constructor de Modelo de libros (Library).... buscarle otro sitio....

    class func bookWithJSONDictionary(json: [String:String], context: NSManagedObjectContext) {
        //Compruebo que estén todos los datos correctos en el JSONDictionary
        guard let title = json["title"] else {return}
        guard let authorsString = json["authors"] else {return}
        guard let tagsString = json["tags"] else {return}
        guard let imageURLString = json["image_url"] else {return}
        guard let pdfURLString = json["pdf_url"] else {return}
        
        let abook = unicObjectWithValue(title, forEntity: "Book", forKey: "title", context: context)
        if abook == nil{
            //No existe, lo creo

            let authorsArray = parseStringToArray(string: authorsString)
            let authorsObjcs = Author.arrayAuthorsWithArrayOfString(authors: authorsArray, context: context)
            
            let tagsArray = parseStringToArray(string: tagsString)
            let tagsObjs = BookTag.arrayTagWithArrayOfStrings(arrayTagsString: tagsArray, context: context)
            
            let cover = BookCoverPhoto.coverPhotoWithURL(url: imageURLString, context: context)
            let pdfObj = PDF.pdfWithURL(urlString: pdfURLString, context: context)
            
            let b = Book(title: title, authors: authorsObjcs, tags: tagsObjs, cover: cover, pdf: pdfObj, context: context)
            
        }

    }

    
}
