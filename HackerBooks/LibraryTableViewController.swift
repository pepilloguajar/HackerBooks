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
    let model : Library
    
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
        
        cell?.imageView?.image = UIImage(named: "bookDefault.jpg")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: (book?.urlBookCover)! )
            DispatchQueue.main.async {
                if let img = UIImage(data: data!){
                    cell?.imageView?.image = img
                }
            }
        }
        
        cell?.textLabel?.text = book?.title
        cell?.detailTextLabel?.text = book?.authorsName
        
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
    
}


















