//
//  Tag+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension Tag{
    
    convenience init(name: String, context: NSManagedObjectContext){
        self.init(context: context)
        self.name = name
        if name == Constants.favoriteTag{
            self.proxyForSorting = "00\(name)"
        }else{
            self.proxyForSorting = name
        }
        
    }
    
    class func tagsAll() -> NSFetchRequest<Tag>{
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "proxyForSorting", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }

    
    
}



