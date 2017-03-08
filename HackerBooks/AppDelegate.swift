//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 22/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var context: NSManagedObjectContext?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //Obtenemos el container y guardamos el contexto
        let container = persistentContainer(dbName: "HackerBooks") { (error: NSError) in
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        self.context = container.viewContext

        let lVC = LibraryTableViewController()
        lVC.context = context
        
        let nav = UINavigationController(rootViewController: lVC)
        
        // Lo añadimos a la window
        self.window?.rootViewController = nav
        
        // Mostramos la window
        self.window?.makeKeyAndVisible()

        return true
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let context = self.context else{
            return
        }
        saveContext(context: context)
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        guard let context = self.context else{
            return
        }
        saveContext(context: context)
    }

    
    // MARK: - Split View
  /*
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
    
    */

}

