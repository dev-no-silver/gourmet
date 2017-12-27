//
//  Favorite.swift
//  GourmetSearch
//
//  Created by Yasunari Kondo on 2017/12/24.
//  Copyright © 2017年 Yasunari Kondo. All rights reserved.
//

import Foundation

public struct Favorite {
    public static var favorites = [String]()
    static let FavoritesKey = "favorites"
    
    public static func load() {
        let ud = UserDefaults.standard
        ud.register(defaults: [FavoritesKey: [String]()])
        favorites = ud.object(forKey: FavoritesKey) as! [String]
    }
    
    public static func save() {
        let ud = UserDefaults.standard
        ud.set(favorites, forKey: FavoritesKey)
        ud.synchronize()
    }
    
    public static func add(_ gid: String) {
        if favorites.contains(gid) {
            remove(gid)
        }
        favorites.append(gid)
        save()
    }
    
    public static func remove(_ gid: String) {
        if let index = favorites.index(of: gid) {
            favorites.remove(at: index)
        }
        save()
    }
    
    public static func toggle(_ gid: String) {
        if inFavorites(gid) {
            remove(gid)
        } else {
            add(gid)
        }
    }
    
    public static func inFavorites(_ gid: String) -> Bool {
        return favorites.contains(gid)
    }
    
    public static func move(_ sourceIndex: Int, to destinationIndex: Int) {
        if sourceIndex >= favorites.count || destinationIndex >= favorites.count {
            return
        }
        
        let srcGid = favorites[sourceIndex]
        favorites.remove(at: sourceIndex)
        favorites.insert(srcGid, at: destinationIndex)
        save()
    }
}
