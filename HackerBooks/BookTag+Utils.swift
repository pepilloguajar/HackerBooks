//
//  BookTag+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension BookTag{
    
    convenience init(name: String, context: NSManagedObjectContext){
        self.init(context: context)
        self.name = name
    }
    
    class func arrayTagWithArrayOfStrings(arrayTagsString: [String], context: NSManagedObjectContext) -> [BookTag] {
        
        let arrayTagsObj: [BookTag] = arrayTagsString.map( { BookTag(name: $0, context: context) })
        return arrayTagsObj
        
    }
    
}
