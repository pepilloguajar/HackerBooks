//
//  NoteCell.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class NoteCell: UICollectionViewCell{
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    private var _note: Annotation? = nil
    
    var note: Annotation{
        get{
            return _note!
        }
        set{
            _note = newValue
            textLabel.text = newValue.text
        }
    
    }
    
    
}
