//
//  MultiDictionary.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 31/1/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import Foundation


public
struct MultiDictionary<Key : Hashable, Value : Hashable>{
    
    //MARK: - Types
    public
    typealias Bucket = Set<Value>
    
    
    //MARK: - Properties
    private
    var _dict : [Key : Bucket]
    
    
    //MARK: - Lifecycle
    
    public
    init(){
        _dict = Dictionary()
    }
    
    
    //MARK: - Accessors
    
    public
    var isEmpty: Bool {
        
        return _dict.isEmpty
    }
    
    public
    var countBuckets : Int {
        return _dict.count
    }
    
    public
    var count : Int{
        
        var total = 0
        for bucket in _dict.values{
            total += bucket.count
        }
        return total
    }
    
    public
    var countUnique : Int {
        var total = Bucket()
        
        for bucket in _dict.values{
            total = total.union(bucket)
        }
        
        return total.count
    }
    
    
    public
    var keys : LazyMapCollection<Dictionary<Key, Bucket>,Key> {
        return _dict.keys
    }
    
    public
    var buckets : LazyMapCollection<Dictionary<Key, Bucket>,Bucket> {
        return _dict.values
    }

    
    //MARK: - Setters (Mutators)
    
    public
    subscript(key: Key) ->Bucket?{
        get{
            return _dict[key]
        }
        
        set(maybeNewBucket){
            guard let newBucket = maybeNewBucket else{
                // añadir nada es no añadir
                return
            }
            
            guard let previous = _dict[key] else{
                // Si no había nada bajo dicha clave
                // la añadimos con un bucket vacio
                _dict[key] = newBucket
                return
            }
            
            // Creamos una unión de lo viejo y lo nuevo
            _dict[key] = previous.union(newBucket)
        }
    }
    
    // Inserta un value a una key pasada. Si no existe la key, la creamos y añadimos el value. Si ya existia no hacemos nada.

    public
    mutating func insert(value: Value, forKey key: Key){
        
        if var previous = _dict[key] {
            previous.insert(value)
            _dict[key] = previous
        }else{
            _dict[key] = [value]
        }
    }
    
    // Eliminamos el "value" de la key que nos pasan. Si no existe ese value para esa key no se hace nada
    // Si después de eliminar queda vacía, eliminamos la key también.
    public
    mutating func remove(value: Value, fromKey key: Key){
        
        guard var bucket = _dict[key] else{
            return
        }
        
        guard bucket.contains(value) else{
            return
        }
        
        bucket.remove(value)
        if bucket.isEmpty{
            _dict.removeValue(forKey: key)
        }else{
            _dict[key] = bucket
        }
    }
}
