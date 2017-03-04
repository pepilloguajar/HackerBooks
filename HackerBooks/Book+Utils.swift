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

    class func bookWithJSONDictionary(json: [String:String], context: NSManagedObjectContext) {
        //Compruebo que estén todos los datos correctos en el JSONDictionary
        guard let title = json["title"] else {return}
        guard let authorsString = json["authors"] else {return}
        guard let tagsString = json["tags"] else {return}
        guard let imageURLString = json["image_url"] else {return}
        guard let pdfURLString = json["pdf_url"] else {return}
        
        let abook = unicObjectWithValue(title, forEntity: "Book", forKey: "title", context: context)
        if let book = abook{
            // El libro con ese título ya está creado y no lo creo. Habría que modificar esto por si cambian datos del libro (autores, tags, etc)

        }else{
            
            //No existe, lo creo

            let authorsArray = parseStringToArray(string: authorsString)
            let authorsObjcs = Author.arrayAuthorsWithArrayOfString(authors: authorsArray, context: context)
            let tagsArray = parseStringToArray(string: tagsString)
            let tagsObjs = BookTag.arrayTagWithArrayOfStrings(arrayTagsString: tagsArray, context: context)
            let cover = BookCoverPhoto.coverPhotoWithURL(url: imageURLString, context: context)
            let pdfObj = PDF.pdfWithURL(urlString: pdfURLString, context: context)
            
            
            let newBook = Book(title: title, authors: authorsObjcs, tags: tagsObjs, cover: cover, pdf: pdfObj, context: context)
            print("\(newBook)")
            

        }

    }

    
}
