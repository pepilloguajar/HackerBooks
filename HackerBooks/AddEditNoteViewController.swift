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
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    
    
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
                let aNote = Annotation.annotationForText(text: self.textNote.text, context: context)
                aNote.book = book
                aNote.creationDate = NSDate()
                aNote.modificationDate = aNote.creationDate
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
    
    @IBAction func deleteNote(_ sender: Any) {
        
        guard let context = book.managedObjectContext else {return}
        guard let note = aNote else{return}
        context.delete(note)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func shareNote(_ sender: Any) {
        if self.textNote.text != ""{
            guard let noteText = self.aNote?.text else{return}
            guard let title = self.book.title else{return}
            guard let url = self.book.pdf?.urlString else {return}
            let text = "Te paso la nota que he tomado del libro \(title): \nNota: \(noteText) \n\(url)"
            guard let img = UIImage(data: self.book.coverPhoto?.data as! Data) else {return}
            
            
            let vc = UIActivityViewController(activityItems: [text, img], applicationActivities: nil)
            self.present(vc, animated: true) {
                print("qué hago aquí")
            }
        }
    }
   
    
    func syncView() {
        guard let text = self.aNote?.text else {return}
        self.oldText = text
        if let label = self.textNote{
            label.text = text
        }
        self.trashButton.isEnabled = true
        self.photoButton.isEnabled = true
       
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoView"{
            guard let context = book.managedObjectContext else {return}
            if aNote == nil{
                let aNote = Annotation.annotationForText(text: self.textNote.text, context: context)
                aNote.book = book
                aNote.creationDate = NSDate()
                aNote.modificationDate = aNote.creationDate
            }else{
                let newText = self.textNote.text
                if(self.oldText != newText ){
                    aNote?.text = newText
                    aNote?.modificationDate = NSDate()
                }
            }

            let vc = segue.destination as! PhotoViewController
            vc.aNote = aNote
        }
        
    }
    



}
