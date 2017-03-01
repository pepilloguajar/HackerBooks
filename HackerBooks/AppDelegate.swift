//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 22/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var lVC: LibraryTableViewController?
    var bookVC: BookViewController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Crear una instancia del modelo -- lanza errores por lo que tenemos que poner un do-catch
        do{
            
            //MARK: - UserDefaults
            //Favorites data
            let userData = UserDefaults.standard

            if (userData.array(forKey: Constants.keyFavoriteForUserDefaults) == nil){
                userData.setValue([], forKeyPath: Constants.keyFavoriteForUserDefaults)
            }
            let arrayFavorites = userData.array(forKey: Constants.keyFavoriteForUserDefaults) as! [Int]

            
            // Array de diccionares de JSON
            let json = try loadFromLocalFile(fileName: "books_readable.json")
            
            // Crear un array de clases de Swift
            var books = [Book]()
            for dict in json{
                do{
                    let aBook = try decode(book: dict)
                    if arrayFavorites.contains(aBook.hashValue){
                        // Lo marcamos como favorito
                        aBook.addTagFavorite()
                    }
                    books.append(aBook)
                }catch{
                    print("Error al procesar \(dict)")
                }
                
            }
            //userData.set(books, forKey: "Modelo")
            //userData.setValue(books, forKey: "Model")
           
            
            let model = Library(books: books)

            
            // Creamos VC
            lVC = LibraryTableViewController(model: model)
            guard let lVC = lVC else {
                return true
            }
            
            // Creamos el navigation controller
            let lNav = UINavigationController(rootViewController: lVC)
            
            let aBook = model.book(fotTagName: model.tags[0], at: 0)
            bookVC = BookViewController(model: aBook!)
            guard let bookVC = bookVC else { return true }
            
            let bookNav = UINavigationController(rootViewController: bookVC)
            
        
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [lNav,bookNav]
            
            //display mode bouttom item
            let navController = splitVC.viewControllers[splitVC.viewControllers.count-1] as! UINavigationController
            
            navController.topViewController?.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
            
            //Asigno delegados
            lVC.delegate = bookVC
            splitVC.delegate = self
            
            
            
            // Lo añadimos a la window
            window?.rootViewController = splitVC
            
            // Mostramos la window
            window?.makeKeyAndVisible()

            return true
            
        }catch{
            fatalError("Error while loading Model from JSON")
        }

        
        
        return true
    }


    
    // MARK: - Split View
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
    func primaryViewController(forExpanding splitViewController: UISplitViewController) -> UIViewController? {
        if let lVC = lVC{
            lVC.delegate = bookVC
        }
        
        return splitViewController.viewControllers.first
    }
    
    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        if let lVC = lVC {
            lVC.delegate = lVC
        }
    
        return splitViewController.viewControllers.first
    }
    
    

}

