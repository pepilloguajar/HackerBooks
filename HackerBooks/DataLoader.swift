//
//  DataLoader.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 5/2/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation

//MARK: - Save/Load File

func getDocumentsURL() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(_ filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}


func saveFile(data: Data, withName fileName: String) {
    let filePath = fileInDocumentsDirectory(fileName)
    saveData(data, path: filePath)
}


func loadFile(fileName: String) -> Data? {
    let filePath = fileInDocumentsDirectory(fileName)
    if let loadedData = loadData(filePath) {
        // Handle data however you wish
        return loadedData
    }
    return nil
    
}

func saveData(_ data: Data, path: String ) {
    
    try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
    
}

func loadData(_ path: String) -> Data? {
    
    let data:Data? = try? Data(contentsOf: URL(fileURLWithPath: path))
    
    return data
    
}
