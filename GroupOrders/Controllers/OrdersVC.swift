//
//  OrdersVC.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/4/22.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController {

    var orders = [Order]()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        SheetDBController.shared.getData { (orders) in
//            self.orders = orders!
////            print(orders!)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                print("reload table view")
//            }
//
//        }
        
        // MARK: - Test API
//        SheetDBController.shared.testGetData {
//            (result) in
//            print("result is: \(result!)")
//            orders = result!
//            tableView.reloadData()
//
//        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table View
extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderCell
        
        let order = orders[indexPath.row]
        
        cell.nameLabel.text = "姓名：\(order.name)"
        cell.sugarLabel.text = "甜度：\(order.sugar)"
        cell.iceLabel.text = "冰塊：\(order.ice)"
        cell.sizeLabel.text = "大小：\(order.size)"
        cell.mixinLabel.text = "加料：\(order.mixin ?? "")"
        cell.priceLabel.text = "\(order.price ?? "")元"
        cell.commentLabel.text = "備註：\(order.comment ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let DBno = self.orders[indexPath.row].no
            SheetDBController.shared.deleteData(DBno: DBno)
            
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        var config = UISwipeActionsConfiguration()
        config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    
}
