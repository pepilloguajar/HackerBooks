//
//  File.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 2/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData


func unicObjectWithValue(_ value: String, forEntity: String, forKey: String, context : NSManagedObjectContext) -> Any?{
    var objs: [Any]?
    
    switch forEntity {
    case "Book":
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    case "Tag":
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    case "BookTag":
        let fetchRequest: NSFetchRequest<BookTag> = BookTag.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    case "Author":
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    case "BookCoverPhoto":
        let fetchRequest: NSFetchRequest<BookCoverPhoto> = BookCoverPhoto.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    case "PDF":
        let fetchRequest: NSFetchRequest<PDF> = PDF.fetchRequest()
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "%K = %@", forKey, value)
        do {
            objs = try context.fetch(fetchRequest)
        } catch  {
            print("error")
        }
    default:
        return nil
    }
    
    guard let results = objs else {
        return nil
    }
    if results.count > 0{
        return results[0]
    }else{
        return nil
    }
    
    
}



