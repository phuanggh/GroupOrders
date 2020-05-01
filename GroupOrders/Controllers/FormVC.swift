//
//  ViewController.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/4/22.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class FormVC: UIViewController {

    var isNewOrder = true
    
    // For API data transfer
    var newOrder = Order()
//    var id = ""
    var item = ""
    var name = ""
    var sugar: SugarLevel = .normal
    var ice: IceLevel = .full
    var size: SizeLevel = .big
    var price = ""
    var comment = ""
    
    
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var itemTextFieldOutlet: UITextField!
    @IBOutlet weak var sugarSegOutlet: UISegmentedControl!
    @IBOutlet weak var hotSwitchOutlet: UISwitch!
    @IBOutlet weak var iceSegOutlet: UISegmentedControl!
    @IBOutlet weak var sizeSegOutlet: UISegmentedControl!
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

    
    @IBAction func orderListButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "formToOrdersVCSegue", sender: "list")
            print(sender.tag)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
//        returnData()
        
        if nameTextFieldOutlet.text?.isEmpty == false, itemTextFieldOutlet.text?.isEmpty == false, priceTextFieldOutlet.text?.isEmpty == false {
        
            if isNewOrder {
                performSegue(withIdentifier: "formToOrdersVCSegue", sender: "submitNewOrder")
    //            print(sender.tag)
                print("submit button pressed: \(isNewOrder)")
            } else {
                performSegue(withIdentifier: "unwindToOrderVC", sender: "editOrder")
                print("submit button pressed: \(isNewOrder)")
            }
            
        } else {
            if nameTextFieldOutlet.text?.isEmpty == true {
                nameTextFieldOutlet.layer.borderWidth = 1
                nameTextFieldOutlet.layer.borderColor = UIColor.systemPink.cgColor
            } else {
                nameTextFieldOutlet.layer.borderColor = UIColor.clear.cgColor
            }
            
            if itemTextFieldOutlet.text?.isEmpty == true {
                itemTextFieldOutlet.layer.borderWidth = 1
                itemTextFieldOutlet.layer.borderColor = UIColor.systemPink.cgColor
            } else {
                itemTextFieldOutlet.layer.borderColor = UIColor.clear.cgColor
            }
            
            if priceTextFieldOutlet.text?.isEmpty == true {
                priceTextFieldOutlet.layer.borderWidth = 1
                priceTextFieldOutlet.layer.borderColor = UIColor.systemPink.cgColor
            } else {
                priceTextFieldOutlet.layer.borderColor = UIColor.clear.cgColor
            }
        }
        

        
    }
    
    func submitNewOrder() {
        
        newOrder.name = nameTextFieldOutlet.text ?? ""
        newOrder.item = itemTextFieldOutlet.text ?? ""
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


    }
    
    
    // MARK: - Segue
    
    @IBAction func unwindToFormVC(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! OrdersVC
        
        let sender = sender as! String
//        print(sender.tag)
        if sender == "submitNewOrder" {
        
            submitNewOrder()
            SheetDBController.shared.postData(newOrder: newOrder) {
                print("post data")
                
                SheetDBController.shared.getData { (orders) in
                    destinationVC.orders = orders!
                           
                    DispatchQueue.main.async {
                        destinationVC.tableView.reloadData()
                        print("get data")
                    }
                            
                }
            }
        
        } else if sender == "editOrder" {
            submitNewOrder()
            SheetDBController.shared.putData(updatedOrder: newOrder, DBID: newOrder.id) {
                
                SheetDBController.shared.getData { (orders) in
                    destinationVC.orders = orders!
                           
                    DispatchQueue.main.async {
                        destinationVC.tableView.reloadData()
                        print("get data")
                    }
                            
                }
            }
            
        } else {
            
            SheetDBController.shared.getData { (orders) in
                destinationVC.orders = orders!
                
                DispatchQueue.main.async {
                    destinationVC.tableView.reloadData()
                    print("get data")
                }
                            
            }
        }
    }



    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("view did load: \(isNewOrder)")

//        SheetDBController.shared.testGetData { (orders) in
//            print(orders)
//        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        isNewOrder = true
        nameTextFieldOutlet.text = name
        itemTextFieldOutlet.text = item
        priceTextFieldOutlet.text = price
        commentTextFieldOutlet.text = comment
        
        switch sugar {
        case .normal:
            sugarSegOutlet.selectedSegmentIndex = 0
        case .seventy:
            sugarSegOutlet.selectedSegmentIndex = 1
        case .half:
            sugarSegOutlet.selectedSegmentIndex = 2
        case .thirty:
            sugarSegOutlet.selectedSegmentIndex = 3
        case .zero:
            sugarSegOutlet.selectedSegmentIndex = 4
        }
        
        
        switch ice {
        case .full:
            iceSegOutlet.selectedSegmentIndex = 0
            hotSwitchOutlet.isOn = false
        case .less:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 1
        case .no:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 2
        case .zero:
            hotSwitchOutlet.isOn = false
            iceSegOutlet.selectedSegmentIndex = 3
        case .hot:
            hotSwitchOutlet.isOn = true
            iceSegOutlet.isEnabled = false
        }

        switch size {
        case .big:
            sizeSegOutlet.selectedSegmentIndex = 0
        case .medium:
            sizeSegOutlet.selectedSegmentIndex = 1
            
        }


        
    }


}

