//
//  LibraryController+NSFetchResultControllerSearch.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 8/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import CoreData

extension LibraryTableViewController {
    
    var fetchedResultsControllerSearch: NSFetchedResultsController<Book> {
        if _fetchedResultsControllerSearch != nil {
            return _fetchedResultsControllerSearch!
        }
        

        if let titleSeach = self.searchController.searchBar.text {
            _fetchedResultsControllerSearch = NSFetchedResultsController(fetchRequest: Book.bookForSearch(titleSeach), managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
        }
        _fetchedResultsControllerSearch?.delegate = self
        
        do {
            try _fetchedResultsControllerSearch!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsControllerSearch!
    }
    
    
    
    // Delegate NSFetchedResultsControllerDelegate
    
    // MARK: - NSFetchedResultController delegate
    
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//        case .delete:
//            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        default:
//            return
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            self.configureCell(tableView.cellForRow(at: indexPath!)!, withBook: anObject as! Book)
//        case .move:
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.endUpdates()
//    }
    
    
    
}
