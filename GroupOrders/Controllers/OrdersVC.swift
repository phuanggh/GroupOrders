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

    
    @IBOutlet weak var numOfTotalItemLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numOfTotalItemLabel.text = String(orders.count)

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
    


    // MARK: - Segue


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FormVC
        let sender = sender as! Int
        
//        if sender == "orderCell" {
        destinationVC.isNewOrder = false
        
//        let row = tableView.indexPathForSelectedRow?.row
        
        let selectedItem = orders[sender]

//        destinationVC.id = selectedItem.id
        destinationVC.newOrder.id = selectedItem.id
        destinationVC.name = selectedItem.name
        destinationVC.item = selectedItem.item
        destinationVC.price = selectedItem.price ?? ""
        destinationVC.comment = selectedItem.comment ?? ""

        switch selectedItem.sugar {
        case SugarLevel.normal.rawValue:
            destinationVC.sugar = .normal
        case SugarLevel.seventy.rawValue:
            destinationVC.sugar = .seventy
        case SugarLevel.half.rawValue:
            destinationVC.sugar = .half
        case SugarLevel.thirty.rawValue:
            destinationVC.sugar = .thirty
        case SugarLevel.zero.rawValue:
            destinationVC.sugar = .zero
        default:
            destinationVC.sugar = .normal
        }
        
        switch selectedItem.ice {
        case IceLevel.full.rawValue:
            destinationVC.ice = .full
        case IceLevel.less.rawValue:
            destinationVC.ice = .less
        case IceLevel.no.rawValue:
            destinationVC.ice = .no
        case IceLevel.zero.rawValue:
            destinationVC.ice = .zero
        case IceLevel.hot.rawValue:
            destinationVC.ice = .hot
        default:
            destinationVC.ice = .full
        }

        switch selectedItem.size {
        case SizeLevel.big.rawValue:
            destinationVC.size = .big
        case SizeLevel.medium.rawValue:
            destinationVC.size = .medium
        default:
            destinationVC.size = .big
        }


    }
    
    @IBAction func unwindToOrderVC(_ unwindSegue: UIStoryboardSegue) {
        
    }


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
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            let DBno = self.orders[indexPath.row].id
            SheetDBController.shared.deleteData(DBno: DBno)
            
            self.orders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            
            self.performSegue(withIdentifier: "orderToFormVCSegue", sender: indexPath.row)
            
            completion(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        
        var config = UISwipeActionsConfiguration()
        config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        performSegue(withIdentifier: "orderToFormVCSegue", sender: nil)
//    }
    
}
