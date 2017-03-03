//
//  Author+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension Author{
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.fullName = name
        
    }
    
    class func arrayAuthorsWithArrayOfString(authors: [String], context: NSManagedObjectContext) -> [Author]{
        
        let authorsArray: [Author] = authors.map( { Author(name: $0, context: context) })
        return authorsArray
        
    }
    
}
