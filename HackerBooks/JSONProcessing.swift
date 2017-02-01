//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 31/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
/*
{
    "authors":      "Scott Chacon, Ben Straub",
    "image_url":    "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
    "pdf_url":      "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
    "tags":         "version control, git",
    "title":        "Pro Git"
}
 */

//MARK: - Alias
typealias JSONObject = String
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Decodificacion
func decode(book dict: JSONDictionary) throws -> Book {
    
    let title = dict["title"]!
    
    let authors = parseStringToArray(string: dict["authors"]!)
    
    let tags = Tags(parseStringToArray(string: dict["tags"]!).map({Tag(name: $0)}))
    
    let imageUrlString = dict["image_url"]!
    let imageURL = URL(string: imageUrlString)!
    
    let pdfUrlString = dict["pdf_url"]!
    let pdfUrl = URL(string: pdfUrlString)!
    
    return Book(title: title, authors: authors, tags: tags, urlBookCover: imageURL, urlBookPDF: pdfUrl)
    
}

func decode(book dict: JSONDictionary?) throws -> Book  {
    
    guard let dict = dict else {
        throw HackerBooksError.nilJSONObject
    }
    return try decode(book: dict)
    
}


//MARK: - Loading
func loadFromLocalFile(fileName name : String, bundle: Bundle = Bundle.main) throws -> JSONArray{
    
    if let url = bundle.url(forResource: name),
        let data = try? Data(contentsOf: url),
        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray{
        
        return array
        
    }else{
        throw HackerBooksError.jsonParsingError
    }
    
}



//MARK: Utils
//Parseo de autores y tags
func parseStringToArray(string : String) -> [String]{
    return string.components(separatedBy: ",").map({$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)})
}


