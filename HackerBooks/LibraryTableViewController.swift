//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 2/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: UITableViewController {
    
    //Core Data
    internal var _fetchedResultsController: NSFetchedResultsController<BookTag>? = nil
    internal var context: NSManagedObjectContext?

    
    
    //MARK: - Constants
    static let notificationName = Notification.Name(rawValue: "BookDidChange")
    static let bookKey = "BookKey"
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        //subscribe()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribe()
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        do {
            let objs = try self.context?.fetch(Tag.tagsAll())
            guard let objsOk = objs else{return 1}
            let a = objsOk.map({$0.name!})
            return objsOk.count
        } catch  {
            print("error in number of section")
            return 1
        }
        

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        do {
            let objs = try self.context?.fetch(Tag.tagsAll())
            guard let objsOk = objs else{return 1}
            let row = (objsOk[section].bookTags?.count)!
            return row
        } catch  {
            print("error in number of section")
            return 0
        }
        
        //return self.fetchedResultsController.sections![section].numberOfObjects
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        do {
            let objs = try self.context?.fetch(Tag.tagsAll())
            guard let objsOk = objs else{return "Error...."}
            return objsOk[section].name
            } catch  {
            print("error in number of section")
            return "Error..."

        }
    }
    
    
    //Utils tabla
    func configureCell(_ cell: UITableViewCell, withBook book: Book) {
        cell.textLabel!.text = book.title
        guard let authorsSet = book.authors else { return }
        let authors = stringToNSSetAuthors(aSet: authorsSet)
        cell.detailTextLabel?.text = authors
        cell.imageView?.image = UIImage(named: "bookDefault.jpg")
        
        guard let coverObj = book.coverPhoto else { return }
        if let cover = coverObj.data{
            cell.imageView?.image = UIImage(data: cover as Data)
        }else{
            //Descarglo la imagen
//            print("A descargar y guardar")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: (URL(string:coverObj.remoteURLString!))! )
                DispatchQueue.main.async {
                    guard let dataOk = data else{ return }
                    if let img = UIImage(data: dataOk){
                        cell.imageView?.image = img
                        //Lo guardo en local y guardo su URL
                        coverObj.data = dataOk as NSData?
                    }
                }
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellId = "BookCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil{
            // El opcional está vacio y creamos la celda
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        guard let acell = cell else { return cell! }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let bookTag = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(acell, withBook: bookTag.books!)
        return acell
        
        
    }
    
    //MARK: - TableView Dalegate
    //Al seleccionar un elemento de la tabla
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self._fetchedResultsController?.object(at: indexPath)
        guard let bookTag = obj, let context = context else {return}
        let bookVC = BookViewController(book: bookTag.books!, context: context)
        
        self.navigationController?.pushViewController(bookVC, animated: true)
        
        
        
        
        /*
        let tag = tagForSection(section: indexPath.section)
        guard let book = model.book(fotTagName: tag, at: indexPath.row) else{
            return
        }
        
        //        let bookVC = BookViewController(model: book!)
        
        //        self.navigationController?.pushViewController(bookVC, animated: true)
        
        
        // Avisamos al delegado
        delegate?.libraryTableViewController(self, didSelectBook: book)
       
        //Enviamos Notificacion 
        notify(bookChanged: book)
 */
        
    }
    
    
//    //MARK: - Utils
//    func tagForSection(section: Int) -> Tag {
//        return model.tags[section]
//    }
    
    
    

}


//MARK: - Protocolo
protocol LibraryTableViewControllerDelegate : class {
    
    func libraryTableViewController(_ lCV: LibraryTableViewController, didSelectBook book: Book )
    
    
}

/*
 
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


extension LibraryTableViewController: LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(_ lCV: LibraryTableViewController, didSelectBook book: Book ){
        let bookVC = BookViewController(model: book)
        lCV.navigationController?.pushViewController(bookVC, animated: true)
    }
    
}



*/










