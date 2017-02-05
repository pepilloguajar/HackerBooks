//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 2/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    //MARK: - Constants
    static let notificationName = Notification.Name(rawValue: "BookDidChange")
    static let bookKey = "BookKey"
    
        
    //MARK: - Properties
    var model : Library
    
    // property delegate
    weak var delegate : LibraryTableViewControllerDelegate?

    
    //MARK: - Init
    init(model: Library){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        subscribe()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }
    



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return model.tagCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.bookCount(forTagName: tagForSection(section: section))
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagForSection(section: section).name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellId = "BookCell"
        
        let tag = tagForSection(section: indexPath.section)
        
        let book = model.book(fotTagName: tag, at: indexPath.row)
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil{
            // El opcional está vacio y creamos la celda
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell?.textLabel?.text = book?.title
        cell?.detailTextLabel?.text = book?.authorsName
        cell?.imageView?.image = UIImage(named: "bookDefault.jpg")
        
        // Cargo las imágenes del libro 
        // Si no están descargadas las descargo y guardo
        // Si están descargadas las muestro
        if let dataImg = loadFile(fileName: String(book!.urlBookCover.hashValue)){
            cell?.imageView?.image = UIImage(data: dataImg)
            
        }else{
            // para no bloquear UI
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: (book?.urlBookCover)! )
                DispatchQueue.main.async {
                    if let img = UIImage(data: data!){
                        cell?.imageView?.image = img
                        //Lo guardo en local y guardo su URL
                        saveFile(data: data!, withName: String(book!.urlBookCover.hashValue))
                    }
                }
            }
        }

        
        return cell!
        
    }
    
    //MARK: - TableView Dalegate
    // Al seleccionar un elemento de la tabla
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tag = tagForSection(section: indexPath.section)
        let book = model.book(fotTagName: tag, at: indexPath.row)
        
        //        let bookVC = BookViewController(model: book!)
        
        //        self.navigationController?.pushViewController(bookVC, animated: true)
        
        
        // Avisamos al delegado
        delegate?.libraryTableViewController(self, didSelectBook: book!)
       
        //Enviamos Notificacion 
        notify(bookChanged: book!)
        
    }
    
    
    //MARK: - Utils
    func tagForSection(section: Int) -> Tag {
        return model.tags[section]
    }
    
    
    

}


//MARK: - Protocolo
protocol LibraryTableViewControllerDelegate : class {
    
    func libraryTableViewController(_ lCV: LibraryTableViewController, didSelectBook book: Book )
    
    
}


//MARK: - Notifications
extension LibraryTableViewController{
    
    func notify(bookChanged book : Book){
        
        let nc = NotificationCenter.default
        
        let noti = Notification(name: LibraryTableViewController.notificationName, object: self, userInfo: [LibraryTableViewController.bookKey : book])
        
        nc.post(noti)
    }
    
    
    
    func subscribe() {
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: BookViewController.notiFavoriteBook, object: nil, queue: OperationQueue.main) { (noti : Notification) in
            let aBook = noti.userInfo?[BookViewController.notiBookKey] as! Book
            
            let userData = UserDefaults.standard
            guard var arrayFavorites = userData.array(forKey: Constants.keyFavoriteForUserDefaults) as! [Int]? else{
                return
            }
            
            if aBook.containsFavoriteTag(){
                self.model.books.insert(value: aBook, forKey: Tag.favoriteTag)
                arrayFavorites.append(aBook.hashValue)
                userData.setValue(arrayFavorites, forKeyPath: Constants.keyFavoriteForUserDefaults)
            }else{
                self.model.books.remove(value: aBook, fromKey: Tag.favoriteTag)
                arrayFavorites = arrayFavorites.filter({ $0 != aBook.hashValue })
                userData.setValue(arrayFavorites, forKeyPath: Constants.keyFavoriteForUserDefaults)
            }
            self.tableView.reloadData()
            
        }
        
    }
    
    func unsubscribe() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
}
















