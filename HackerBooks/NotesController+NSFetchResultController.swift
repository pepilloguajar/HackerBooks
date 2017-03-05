//
//  NotebooksController+NSFetchResultController.swift
//  Everpobre
//
//  Created by Jose Javier Montes Romero on 21/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import CoreData

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Annotation> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: Annotation.AnnotationForBook(book: self.book), managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: self.book.title)
        _fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    
    // Delegate NSFetchedResultsControllerDelegate
    
    // MARK: - NSFetchedResultController delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .delete:
            self.collectionView.deleteSections(IndexSet(integer: sectionIndex))
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    
    
    
}
