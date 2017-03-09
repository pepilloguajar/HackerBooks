//
//  CoreDataManager.swift
//  Everpobre
//
//  Created by Jose Javier Montes Romero on 21/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import CoreData
    
public  func persistentContainer(dbName: String, onError: ((NSError) -> Void)? = nil) ->  NSPersistentContainer {
    let container = NSPersistentContainer(name: dbName)
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError?, let onError = onError {
            onError(error)
        }
    })
    return container
}


//TODO: addOnError
public  func saveContext(context: NSManagedObjectContext) {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            _ = error as NSError
            //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

