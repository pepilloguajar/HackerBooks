//
//  AddEditNoteViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class AddEditNoteViewController: UIViewController {
    
    var book: Book!
    var aNote: Annotation?
    
    var oldText: String?
    
    @IBOutlet weak var textNote: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Nota - \(book.title!)"
        
        if aNote != nil{
            syncView()
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.textNote.text != ""{
            
            guard let context = book.managedObjectContext else {return}
            
            if aNote == nil{
                let note = Annotation.annotationForText(text: self.textNote.text, context: context)
                note.book = book
                note.creationDate = NSDate()
                note.modificationDate = note.creationDate
            }else{
                let newText = self.textNote.text
                if(self.oldText != newText ){
                    aNote?.text = newText
                    aNote?.modificationDate = NSDate()
                }
            }
            
            saveContext(context: context)
        }
        
    }
    
    
    func syncView() {
        self.oldText = self.aNote?.text!
        self.textNote.text = self.oldText
    }


    



}
