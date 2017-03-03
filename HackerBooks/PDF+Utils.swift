//
//  PDF+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension PDF{
    
    convenience init(urlString: String, context: NSManagedObjectContext){
        self.init(context: context)
        self.urlString = urlString
    }
    
    class func pdfWithURL(urlString: String, context: NSManagedObjectContext) -> PDF{
        return PDF(urlString: urlString, context: context)
    }
    
}
