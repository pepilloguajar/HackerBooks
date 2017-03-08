//
//  UtilsFunctions.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 4/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

func stringToNSSetAuthors(aSet: NSSet) -> String{
    let array: [String] = aSet.allObjects.map{ ($0 as! Author).fullName!}.sorted()
    return array.joined(separator: ", ")
    
    
}

func stringToNSSetTags(aSet: NSSet) -> String{
    let arrayBookTag: [BookTag] = aSet.allObjects.map{ $0 as! BookTag }
    let array : [String] = arrayBookTag.map{ $0.name! }
    return array.joined(separator: ", ")
    
    
}

//Parseo de autores y tags
func parseStringToArray(string : String) -> [String]{
    return string.components(separatedBy: ",").map({$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).capitalized})
}
