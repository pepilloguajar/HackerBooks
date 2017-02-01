//
//  Errors.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 31/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

enum HackerBooksError : Error {
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
    
}
