//
//  BookTag+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension BookTag{
    
    convenience init(name: String, tag: Tag, context: NSManagedObjectContext){
        self.init(context: context)
        self.name = name
        self.tag = tag
    }
    
    class func bookTagsAll() -> NSFetchRequest<BookTag>{
        let fetchRequest: NSFetchRequest<BookTag> = BookTag.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let tagsOrder = NSSortDescriptor(key: "tag.proxyForSorting", ascending: true)
        let titleBook = NSSortDescriptor(key: "books.title", ascending: true)
        
        fetchRequest.sortDescriptors = [tagsOrder,titleBook]
        
        
        
        return fetchRequest
    }
    
    class func bookForSearch(_ text: String) -> NSFetchRequest<BookTag>{
        
        let fetchRequest: NSFetchRequest<BookTag> = BookTag.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        

        let titleBook = NSSortDescriptor(key: "books.title", ascending: true)
        fetchRequest.sortDescriptors = [titleBook]
        
        fetchRequest.predicate = NSPredicate(format: "books.title contains[c] %@ OR name contains[c] %@ OR books.authors.fullName contains[c] %@" , argumentArray: [text, text, text])


        return fetchRequest
    }

    

    
    class func arrayTagWithArrayOfStrings(arrayTagsString: [String], context: NSManagedObjectContext) -> [BookTag] {
        
        let arrayTagsObj = arrayTagsString.map { (name) -> BookTag in
            
            //Crear el Tag y BookTag
            if let tag = unicObjectWithValue(name, forEntity: "Tag", forKey: "name", context: context){
                return BookTag(name: name, tag: tag as! Tag, context: context)
            }else{
                let aTag = Tag(name: name, context: context)
                return BookTag(name: name, tag: aTag, context: context)
            }

        }
        return arrayTagsObj
        
    }

    
}


extension BookTag : Comparable{
    
    public static func <(lhs: BookTag, rhs: BookTag) -> Bool{
        
        if (lhs.name == Constants.favoriteTag){
            return true
        }else if (rhs.name == Constants.favoriteTag){
            return false
        }else{
            return (lhs.name! < rhs.name!)
        }
        
    }
    
}
