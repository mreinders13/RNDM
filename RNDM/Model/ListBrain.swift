//
//  ListBrain.swift
//  RNDM
//
//  Created by Michael Reinders on 5/18/22.
//

import Foundation

struct ListBrain {
    var listArray: [String] = []
    
    func createList(name:String) {
        let List = standardList.init(title: name, items: listArray)
        savedLists.append(List)
    }
    
    func saveList() {
        // Save List
        if let encoded = try? JSONEncoder().encode(savedLists) {
            UserDefaults.standard.set(encoded, forKey: "Standard-Lists-Array")
        }
    }
}

struct standardList: Codable {
    let title: String
    let items: [String]
}
