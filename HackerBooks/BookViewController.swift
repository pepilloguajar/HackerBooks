//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData

class BookViewController: UIViewController {
    //CoreData
    let context: NSManagedObjectContext
    
    //MARK: - Constants
    static var notiFavoriteBook = Notification.Name(rawValue: "NotiBookFavorite")
    static var notiBookKey = "notiBookKey"

    //MARK: - Properties
    var model : Book
    
    @IBOutlet weak var coverBook: UIImageView!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var favoriteView: UIBarButtonItem!
    
    //MARK: - Init
    init(model: Book, context: NSManagedObjectContext){
        self.model = model
        self.context = context
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewWithModel(book: model)
        self.edgesForExtendedLayout = []
    }
    
    
    
    //MARK: - Sync
    func syncViewWithModel(book: Book){
        

        coverBook.image = UIImage(named: "bookDefault.jpg")
        
        if let dataImg = book.coverPhoto?.data {
           coverBook.image = UIImage(data: dataImg as Data)
        }else{
            // para no bloquear UI
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: (book.coverPhoto?.remoteURLString)!)! )
                DispatchQueue.main.async {
                    guard let dataOk = data else{
                        return
                    }
                    if let img = UIImage(data: dataOk){
                        self.coverBook.image = img
                    }
                }
            }


            
        }
        
        guard let authorsSet = book.authors else { return }
        authors.text  = stringToNSSetAuthors(aSet: authorsSet)
    
        guard let tagsSet = book.tags else { return }
        tags.text = stringToNSSetTags(aSet: tagsSet)
        title = book.title
        
        /*
        if model.containsFavoriteTag(){
            favoriteView.title = "♥"
        }else{
            favoriteView.title = "♡"
        }
 */
        
    }
    

    @IBAction func isFavorite(_ sender: UIBarButtonItem) {

        
        /*
        if !model.containsFavoriteTag() {
            
            model.addTagFavorite()
            syncViewWithModel(book: model)
            notifyFavorite()
            
        }else{
            
            model.removeTagFavorite()
            syncViewWithModel(book: model)
            notifyFavorite()
        }
        */
    }

    @IBAction func readPdf(_ sender: UIBarButtonItem) {
        
        let pdfVC = PDFReaderViewController(model: model)
        // inyecto el contexto por property para probar ambas formas
        pdfVC.context = context
        
        self.navigationController?.pushViewController(pdfVC, animated: true)

    }


    
    
}

/*

//MARK: - Protocolos
extension BookViewController : LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(_ lCV: LibraryTableViewController, didSelectBook book: Book ){
        self.model = book
        syncViewWithModel(book: book)
    }
    
}


//MARK: - Notifications
extension BookViewController{
    
    func notifyFavorite(){
        
        let nc = NotificationCenter.default
        
        let noti = Notification(name: BookViewController.notiFavoriteBook, object: self, userInfo: [BookViewController.notiBookKey : model])
        
        nc.post(noti)
    }
    
    
}



*/








