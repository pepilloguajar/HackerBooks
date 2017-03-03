//
//  BookCoverPhoto.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension BookCoverPhoto{
    
    convenience init(url: String, context: NSManagedObjectContext){
        self.init(context: context)
        self.remoteURLString = url
    }
    
    class func coverPhotoWithURL(url: String, context : NSManagedObjectContext) -> BookCoverPhoto{
        return BookCoverPhoto(url: url, context: context)
    }
    
}
