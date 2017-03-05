//
//  NotebooksController+UICollectionView.swift
//  Everpobre
//
//  Created by Jose Javier Montes Romero on 21/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import UIKit

extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as? NoteCell
        
        cell?.note = self.fetchedResultsController.object(at: indexPath)
        
        return cell!
        
    }
    
    
    
    
}
