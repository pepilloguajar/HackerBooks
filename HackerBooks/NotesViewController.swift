//
//  NotesViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    //CoreData
    internal var _fetchedResultsController: NSFetchedResultsController<Annotation>? = nil
    internal var context: NSManagedObjectContext?
    
    var book: Book!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = self.book.managedObjectContext
        self.title = book.title
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNote"{
            let vc = segue.destination as! AddEditNoteViewController
            vc.book = book
        }else if segue.identifier == "editNote"{
            let indexpath = collectionView.indexPathsForSelectedItems?.first
            let note = _fetchedResultsController?.object(at: indexpath!)
            let vc = segue.destination as! AddEditNoteViewController
            vc.book = book
            vc.aNote = note
        
        }
        
        
    }


    



}
