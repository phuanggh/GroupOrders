//
//  ViewController.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/4/22.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class FormVC: UIViewController {

    var newOrder = Order()
//    var item: String!
//    var name: String!
    var sugar: SugarLevel = .normal
    var ice: IceLevel = .full
    var size: SizeLevel = .big
    var price: String?
//    var comment: String?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var iceSegOutlet: UISegmentedControl!
    @IBOutlet weak var hotSwitchOutlet: UISwitch!
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    @IBOutlet weak var commentTextFieldOutlet: UITextField!
    
    
    @IBAction func sugarSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sugar = .normal
        case 1:
            sugar = .seventy
        case 2:
            sugar = .half
        case 3:
            sugar = .thirty
        case 4:
            sugar = .zero
        default:
            sugar = .normal
        }

        newOrder.sugar = sugar.rawValue
//        print(sugar.rawValue)
    }
    
    @IBAction func hotDrinkSwitch(_ sender: UISwitch) {
        if sender.isOn {
            iceSegOutlet.isEnabled = false
        } else {
            iceSegOutlet.isEnabled = true
        }
    }
    
    @IBAction func iceSegAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ice = .full
        case 1:
            ice = .less
        case 2:
            ice = .no
        case 3:
            ice = .zero
        default:
            ice = .full
        }
        
    }
    
    @IBAction func sizeSegAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            size = .big
        case 1:
            size = .medium
        default:
            size = .big
        }
    }
    
    @IBAction func bigBubble(_ sender: Any) {
    }

    
    @IBAction func submitButtonPressed(_ sender: Any) {
//        returnData()

    }
    
    @IBSegueAction func formToOrderSegueAction(_ coder: NSCoder) -> OrdersVC? {
        let controller = OrdersVC(coder: coder)
        print("segue action triggered")
        
        newOrder.name = nameTextField.text ?? ""
        newOrder.item = itemTextField.text ?? ""
        newOrder.sugar = sugar.rawValue
        newOrder.size = size.rawValue
        newOrder.price = priceTextFieldOutlet.text ?? ""
        
        if hotSwitchOutlet.isOn {
            newOrder.ice = IceLevel.hot.rawValue
        } else {
            newOrder.ice = ice.rawValue
        }
        if commentTextFieldOutlet.text != "" {
            newOrder.comment = commentTextFieldOutlet.text
        }
        
        SheetDBController.shared.postData(newOrder: newOrder) {
            print("post data")
            SheetDBController.shared.getData { (orders) in
                controller?.orders = orders!
               
                DispatchQueue.main.async {
                    controller?.tableView.reloadData()
                    print("get data")
                }
                
            }
        }
        
        
        return controller
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        SheetDBController.shared.testGetData { (orders) in
//            print(orders)
//        }

        
    }


}

