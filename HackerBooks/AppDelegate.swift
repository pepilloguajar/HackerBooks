//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 22/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
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
            let lVC = LibraryTableViewController(model: model)
            
            // Creamos el navigation controller
            let lNav = UINavigationController(rootViewController: lVC)
            
            let aBook = model.book(fotTagName: model.tags[0], at: 0)
            let bookVC = BookViewController(model: aBook!)
            
            let bookNav = UINavigationController(rootViewController: bookVC)
            
            let splitVC = UISplitViewController()
            splitVC.viewControllers = [lNav,bookNav]
            
            //Asigno delegados
            lVC.delegate = bookVC
            
            // Lo añadimos a la window
            window?.rootViewController = splitVC
            
            // Mostramos la window
            window?.makeKeyAndVisible()

            return true
            
        }catch{
            fatalError("Error while loading Model from JSON")
        }

        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

