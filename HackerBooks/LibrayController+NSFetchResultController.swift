//
//  NotebooksController+NSFetchResultController.swift
//  Everpobre
//
//  Created by Jose Javier Montes Romero on 21/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import CoreData

extension LibraryTableViewController: NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<BookTag> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        if(self.searchController.searchBar.text?.lengthOfBytes(using: .utf8) != 0),
            let titleSeach = self.searchController.searchBar.text {
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: BookTag.bookForSearch(titleSeach), managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
        }else{
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: BookTag.bookTagsAll(), managedObjectContext: self.context!, sectionNameKeyPath: "tag.proxyForSorting", cacheName: nil)
        }
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
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withBook: anObject as! Book)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    
    
}
