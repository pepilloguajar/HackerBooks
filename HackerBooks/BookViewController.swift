//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
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
    init(model: Book){
        self.model = model
        
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
        
        if let dataImg = loadFile(fileName: String(book.urlBookCover.hashValue)) {
           coverBook.image = UIImage(data: dataImg)
        }else{
            // para no bloquear UI
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: book.urlBookCover )
                DispatchQueue.main.async {
                    if let img = UIImage(data: data!){
                        self.coverBook.image = img
                    }
                }
            }


            
        }
        
        authors.text = book.authorsName
        tags.text = book.tagsName
        title = book.title
        
        if model.containsFavoriteTag(){
            favoriteView.title = "♥"
        }else{
            favoriteView.title = "♡"
        }
        
    }
    
    
    @IBAction func isFavorite(_ sender: UIBarButtonItem) {

        if !model.containsFavoriteTag() {
            
            model.addTagFavorite()
            syncViewWithModel(book: model)
            notifyFavorite()
            
        }else{
            
            model.removeTagFavorite()
            syncViewWithModel(book: model)
            notifyFavorite()
        }
            
    }
    
    @IBAction func readPdf(_ sender: UIBarButtonItem) {
        
        let pdfVC = PDFReaderViewController(model: model)
        
        self.navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    

    
    
}



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

//MARK: - Save/Load Files
extension BookViewController{
    
    //MARK: - Save/Load File
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    
    func saveFile(data: Data, book: Book) {
        let fileName:String = String(book.urlBookCover.hashValue)
        let filePath = fileInDocumentsDirectory(fileName)
        saveData(data, path: filePath)
    }
    
    
    func loadFile(fileName: String) -> Data? {
        
        let filePath = fileInDocumentsDirectory(fileName)
        if let loadedData = loadData(filePath) {
            // Handle data however you wish
            return loadedData
        }
        return nil
        
    }
    
    func saveData(_ data: Data, path: String ) {
        
        try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
        
    }
    
    func loadData(_ path: String) -> Data? {
        
        let data:Data? = try? Data(contentsOf: URL(fileURLWithPath: path))
        
        return data
        
    }
    
}











