//
//  PDFReaderViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class PDFReaderViewController: UIViewController {

    //MARK: - Properties
    let model : Book
    
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

    }
    
    
    
    //MARK: - Async
    func syncViewWithModel(book : Book) {
        
        loaderIndicator.isHidden = false
        loaderIndicator.startAnimating()
        
        let pdf = Bundle.main.url(forResource: "pdfDefault", withExtension: "pdf")
        let pdfData = try? Data(contentsOf: pdf!)
        
        webView.load(pdfData!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: book.urlBookPDF)
        
        // para no bloquear UI
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: book.urlBookPDF )
            DispatchQueue.main.async {
                if data != nil{
                    self.webView.load(data!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: book.urlBookPDF)
                    self.loaderIndicator.isHidden = true
                    self.loaderIndicator.stopAnimating()
                }
            }
        }
    
    
    }
    
    

}
