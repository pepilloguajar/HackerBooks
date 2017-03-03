//
//  File.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 2/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData


func unicObjectWithValue(_ value: String, forEntity: String, forKey: String, context : NSManagedObjectContext) -> Bool{
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
    default:
        return false
    }
    
    guard let results = objs else {
        return false
    }
    if results.count > 0{
        return true
    }else{
        return false
    }
    
    
}



