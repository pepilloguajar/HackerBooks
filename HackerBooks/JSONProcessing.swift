
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 8/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation
import CoreData

typealias JSONArray = [[String:String]]


func jsonforURL(urlString: String, completion: @escaping (JSONArray) -> Void) {
    if let url = URL(string: urlString){
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error{
                print("Error in download JSON" + error.localizedDescription)
                return
            }
            
            guard let data = data else{return}
            
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSONArray
            guard let aJson = json else{return}
            completion(aJson)
            
        })
        task.resume()
    }
    
}



func downloadAndProcessionJSON (context: NSManagedObjectContext, completion: @escaping () -> ()){
    
    
    let userData = UserDefaults.standard
    if !(userData.bool(forKey: Constants.keyLibraryInCoreData) ){
        
        DispatchQueue.global().async {
            jsonforURL(urlString: Constants.urlAPILibrary, completion: { (json) in
                
                DispatchQueue.main.async{
                    for abook in json{
                        bookWithJSONDictionary(json: abook, context: context)
                    }
                    saveContext(context: context)
                    userData.set(true, forKey: Constants.keyLibraryInCoreData)
                    completion()
                }
            })
        }
    }else{
        completion()
    }
    
}



//MARK: - Constructor de Modelo de libros (Library)

func bookWithJSONDictionary(json: [String:String], context: NSManagedObjectContext) {
    //Compruebo que estén todos los datos correctos en el JSONDictionary
    guard let title = json["title"] else {return}
    guard let authorsString = json["authors"] else {return}
    guard let tagsString = json["tags"] else {return}
    guard let imageURLString = json["image_url"] else {return}
    guard let pdfURLString = json["pdf_url"] else {return}
    
    let abook = unicObjectWithValue(title, forEntity: "Book", forKey: "title", context: context)
    if abook == nil{
        //No existe, lo creo
        
        let authorsArray = parseStringToArray(string: authorsString)
        let authorsObjcs = Author.arrayAuthorsWithArrayOfString(authors: authorsArray, context: context)
        
        let tagsArray = parseStringToArray(string: tagsString)
        let tagsObjs = BookTag.arrayTagWithArrayOfStrings(arrayTagsString: tagsArray, context: context)
        
        let cover = BookCoverPhoto.coverPhotoWithURL(url: imageURLString, context: context)
        let pdfObj = PDF.pdfWithURL(urlString: pdfURLString, context: context)
        
        _ = Book(title: title, authors: authorsObjcs, tags: tagsObjs, cover: cover, pdf: pdfObj, context: context)

    }
    
}


