//
//  Annotation+Utils.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData

extension Annotation{
    
    convenience init(text: String, context: NSManagedObjectContext){
        self.init(context: context)
        self.text = text
    }
    
    class func annotationForText(text: String, context: NSManagedObjectContext) -> Annotation{
        return Annotation(text: text, context: context)
    }
    
    class func AnnotationForBook(book: Book) -> NSFetchRequest<Annotation>{
        let fetchRequest: NSFetchRequest<Annotation> = Annotation.fetchRequest()
        fetchRequest.fetchBatchSize = 10
        
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "book = %@", book)
        
        
        return fetchRequest
    }
    
    
    
}


