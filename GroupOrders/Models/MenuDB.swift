//
//  MenuDB.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/5/1.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import Foundation


struct Item: Decodable {
    let drink: String
    let option: [Option]
    
    struct Option: Decodable {
        let size: String
        let price: Int
        
    }
}


internal struct MenuDBController {
    internal static let shared = MenuDBController()
    
    func getMenuData(completion: @escaping([Item]?) -> ()) {
        let url = Bundle.main.url(forResource: "Menu", withExtension: "plist")!
//        print("\(url)")
        if let data = try? Data(contentsOf: url), let menuItem = try? PropertyListDecoder().decode([Item].self, from: data) {
            completion(menuItem)
//            print(menuItem)
        } else {
            completion(nil)
        }
    }
}

