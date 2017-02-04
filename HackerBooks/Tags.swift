//
//  Tags.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 31/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

struct Tag {
    
    let name : String
    
    init(name: String) {
        self.name = name
    }
    
    //Constants
    static let favoriteTag = Tag(name: "Favorite")
    
}


//MARK: - Protocolos

extension Tag : Equatable{
    
    public static func ==(lhs: Tag, rhs: Tag) -> Bool{
        
        return lhs.name == rhs.name
        
    }
}


extension Tag : Comparable{
    
    public static func <(lhs: Tag, rhs: Tag) -> Bool{
        
        if (lhs.name == favoriteTag.name){
            return true
        }else if (rhs.name == favoriteTag.name){
            return false
        }else{
            return (lhs.name < rhs.name)
        }
        
    }
    
}

// Implemento Hashable para el Multidiccionario
extension Tag : Hashable{
    
    public var hashValue: Int {
        get{
            return name.hashValue
        }
    }
    
}

