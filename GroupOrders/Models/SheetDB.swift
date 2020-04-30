//
//  SheetDB.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/4/23.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

//struct SheetData: Codable {
//    let order: Order
//
//}
struct Order: Codable {
    var id: String
    var name: String
    var item: String
    var sugar: String
    var ice: String
    var size: String
    var mixin: String?
    var price: String
    var comment: String?
    
    init() {
        id = "INCREMENT"
        name = ""
        item = ""
        sugar = ""
        ice = ""
        size = ""
        price = ""
    }
}

enum ParamKey: String {
    //case data
    case name
    case item
    case sugar
    case ice
    case size
    case mixin
    case price
    case comment
}

enum SugarLevel: String {
    case normal = "全糖"
    case seventy = "少糖"
    case half = "半糖"
    case thirty = "微糖"
    case zero = "無糖"
}

enum IceLevel: String {
    case full = "正常"
    case less = "少冰"
    case no = "去冰"
    case zero = "完全去冰"
    case hot = "熱飲"
}

enum SizeLevel: String {
    case big = "大杯"
    case medium = "中杯"
}


internal struct SheetDBController {
    internal static let shared = SheetDBController()
    
    // MARK: - GET
    func getData(completion: @escaping([Order]?) -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/dk4jichclc5qu"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let data = data, let sheetData = try? JSONDecoder().decode([Order].self, from: data) {
                    completion(sheetData)
//                    print(sheetData)
                } else {
                    completion(nil)
                }
            }.resume()
        }

    }
    
    
    //MARK: - POST
    func postData(newOrder: Order, completion: @escaping() -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/dk4jichclc5qu"

        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
//            var postData = newOrder
//            print(newOrder)
            let postData = ["data":newOrder]
            print(postData)
            
            if let data = try? JSONEncoder().encode(postData) {
//                request.httpBody = data
                
                // Decode the return response from API to know if it is successful or failed
                URLSession.shared.uploadTask(with: request, from: data) { returnData, response, error in
//                    print("return data: \(returnData)")
//                    print("response: \(response)")
//                    print("errer: \(error)")
                    if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["created"] == 1 {
                        print("Post succeeded")
                        completion()
                    } else {
                        print("Post failed")
                    }

                }.resume()
                
            }
        }
    }
    
    //MARK: - PUT
    func putData(updatedOrder: Order, DBID: String, completion: @escaping () -> ()) {
        let urlStr = "https://sheetdb.io/api/v1/dk4jichclc5qu/id/\(DBID)"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            
            let putData = ["data":updatedOrder]
//            print("updated order: \(putData)")
            if let data = try? JSONEncoder().encode(putData) {
                URLSession.shared.uploadTask(with: request, from: data) { returnData, response, error in
                    
//                    print("return data: \(returnData)")
//                    print("response: \(response)")
//                    print("errer: \(error)")
                    
                    if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["updated"] == 1 {
                        print("Put succeeded")
                        completion()
                    } else {
                        print("Put failed")
                    }
                }.resume()
            }
        }
        
    }
    
    // MARK: - DELETE
    func deleteData(DBno: String) {
        let urlStr = "https://sheetdb.io/api/v1/dk4jichclc5qu/id/\(DBno)"
        if let url = URL(string: urlStr) {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { returnData, response, error in
                if let returnData = returnData, let dic = try? JSONDecoder().decode([String: Int].self, from: returnData), dic["deleted"] == 1 {
                    print("Delete succeeded")
                } else {
                    print("Delete failed")
                }
            }.resume()
            
        }

    }
    
    
    
    // MARK: - Test API data
    func testGetData(completion: ([Order]?) -> ()) {
        guard let data = NSDataAsset(name: "sheetDB2")?.data else {
           print("data not exist")
           return
        }
        do {
           let decoder = JSONDecoder()
           let result = try decoder.decode([Order].self, from: data)
            completion(result)
           print(result)
        } catch  {
            completion(nil)
           print(error)
        }
    }

    
}


