//
//  PDFReaderViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData

class PDFReaderViewController: UIViewController {
    
    //CoreData
    var context: NSManagedObjectContext?
    
    
    //MARK: - Properties
    var model : Book
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    //MARK: - Init
    init(model : Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        title = model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncViewWithModel(book: model)
        self.edgesForExtendedLayout = []
        
        // alta en la notificación
        subscribe()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // baja en la notificacion
        unsubscribe()
    }
    
    
    
    //MARK: - Async
    func syncViewWithModel(book : Book) {
        
        let baseURL = URL(string: (book.pdf?.urlString!)!)!
        if let dataPdf = book.pdf?.data{
            webView.load(dataPdf as Data, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: baseURL)
        }else{
            
            loaderIndicator.isHidden = false
            loaderIndicator.startAnimating()
            
            guard let pdf = Bundle.main.url(forResource: "pdfDefault", withExtension: "pdf"), let pdfData = try? Data(contentsOf: pdf) else {
                return
            }
            
            webView.load(pdfData, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: baseURL)
            
            // para no bloquear UI
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: baseURL )
                DispatchQueue.main.async {
                    guard let dataOk = data else{
                        return
                    }
                    if data != nil{
                        self.webView.load(dataOk, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: baseURL)
                        self.loaderIndicator.isHidden = true
                        self.loaderIndicator.stopAnimating()
                        book.pdf?.data = data as NSData?
                    }
                }
            }
        }
        
    }
    
    
    
}




//MARK: - Notifications
extension PDFReaderViewController{
    
    func subscribe(){
        
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: LibraryTableViewController.notificationName, object: nil,
                       queue: OperationQueue.main) { (note :Notification) in
                        
                        let aBook = note.userInfo?[LibraryTableViewController.bookKey] as! Book
                        //cambio el modelo
                        self.model = aBook
                        
                        //actulizo las vistas
                        self.syncViewWithModel(book: aBook)
        }
        
    }
    
    func unsubscribe(){
        
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        
    }
    
}


















