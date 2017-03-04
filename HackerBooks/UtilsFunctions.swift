//
//  UtilsFunctions.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 4/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

func stringToNSSetAuthors(aSet: NSSet) -> String{
    let array: [String] = aSet.allObjects.map({ ($0 as! Author).fullName!} )
    return array.joined(separator: ", ")
    
    
}

func stringToNSSetTags(aSet: NSSet) -> String{
    let array: [String] = aSet.allObjects.map({ ($0 as! BookTag).name!} )
    return array.joined(separator: ", ")
    
    
}
