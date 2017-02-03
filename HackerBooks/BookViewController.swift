//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 3/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {


    //MARK: - Properties
    let model : Book
    
    @IBOutlet weak var coverBook: UIImageView!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    //MARK: - Init
    init(model: Book){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        
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
    
    
    
    //MARK: - Sync
    func syncViewWithModel(book: Book){
        

        coverBook.image = UIImage(named: "bookDefault.jpg")
        
        // para no bloquear UI
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: book.urlBookCover )
            DispatchQueue.main.async {
                if let img = UIImage(data: data!){
                    self.coverBook.image = img
                }
            }
        }
        
        authors.text = book.authorsName
        tags.text = book.tagsName
        title = book.title
        
    }
    
    
    @IBAction func isFavorite(_ sender: UIBarButtonItem) {
        print("BTN Favorite pulsado")
    }
    
    @IBAction func readPdf(_ sender: UIBarButtonItem) {
        
        let pdfVC = PDFReaderViewController(model: model)
        
        self.navigationController?.pushViewController(pdfVC, animated: true)
        
    }
}
