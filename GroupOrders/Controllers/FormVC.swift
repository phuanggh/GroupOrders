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
    var mixin = ""
    
    // Menu Data
    var items = [Item]()
    var selectedDrink = 0
    var selectedSize = 0
    
    
    // MARK: UI Outlet
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var itemTextFieldOutlet: UITextField!
    @IBOutlet weak var sugarSegOutlet: UISegmentedControl!
    @IBOutlet weak var hotSwitchOutlet: UISwitch!
    @IBOutlet weak var iceSegOutlet: UISegmentedControl!
    @IBOutlet weak var sizeSegOutlet: UISegmentedControl!
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    @IBOutlet weak var commentTextFieldOutlet: UITextField!
    @IBOutlet weak var addWBubbleButtonOutlet: UIButton!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
    // MARK: UI Action
    
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
//        print(sugar.rawValue)
    }
    
    @IBAction func hotDrinkSwitch(_ sender: UISwitch) {
        if sender.isOn {
            iceSegOutlet.isEnabled = false
            ice = .hot
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
    
    @IBAction func addWBubbleSelected(_ sender: Any) {
        
        addWBubbleButtonOutlet.isSelected = !addWBubbleButtonOutlet.isSelected
        
        if addWBubbleButtonOutlet.isSelected {
            addWBubbleButtonOutlet.layer.borderWidth = 3
            addWBubbleButtonOutlet.layer.borderColor = UIColor(red: 0.73, green: 0.60, blue: 0.41, alpha: 1.00).cgColor
            addWBubbleButtonOutlet.setTitleColor( #colorLiteral(red: 0.7294117647, green: 0.6039215686, blue: 0.4078431373, alpha: 1) , for: .selected)
        } else {
            addWBubbleButtonOutlet.layer.borderWidth = 0
        }
        
        mixin = addWBubbleButtonOutlet.isSelected ? "白玉珍珠" : ""
        
        updateFormPrice()
        
    }
    
    @IBAction func orderListButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "formToOrdersVCSegue", sender: "list")
            print(sender.tag)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
//        returnData()
        
        if nameTextFieldOutlet.text?.isEmpty == false, itemTextFieldOutlet.text?.isEmpty == false {
        
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
            
        }
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "formToPickerSegue", sender: "menu")
    }
    
    
    // MARK: Function Declaration
    
    func submitNewOrder() {
        // need to revise. replace the outlet parts
        newOrder.name = nameTextFieldOutlet.text ?? ""
        newOrder.item = itemTextFieldOutlet.text ?? ""
        newOrder.sugar = sugar.rawValue
        newOrder.size = size.rawValue
        newOrder.price = priceTextFieldOutlet.text ?? ""
        newOrder.ice = ice.rawValue
        newOrder.mixin = mixin
        
        if commentTextFieldOutlet.text != "" {
            newOrder.comment = commentTextFieldOutlet.text
        }

    }
    
    // Update item, size from selected menu item
    func updateFormOutlet() {
        
        if  isNewOrder {
            itemTextFieldOutlet.text = items[selectedDrink].drink
            size = items[selectedDrink].option[selectedSize].size == "L" ? SizeLevel.big : SizeLevel.medium
        } else {
            itemTextFieldOutlet.text = item
            
        }

        switch size {
        case .big:
            sizeSegOutlet.selectedSegmentIndex = 0
        case .medium:
            sizeSegOutlet.selectedSegmentIndex = 1
        
        }
    }
    
    // Deal with mixins and update price UI display
    func updateFormPrice() {
        let mixinPrice = mixin == "" ? 0 : 10
//        print("mixin price : \(mixinPrice)")
        
        if isNewOrder {
            price = String( items[selectedDrink].option[selectedSize].price)
            
        }
        
        let totalPrice = Int(price)! + mixinPrice
        priceTextFieldOutlet.text = String(totalPrice)
    
    }
    
    
    // MARK: - Segue
    
    @IBAction func unwindToFormVC(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        let sender = sender as! String
        
        if sender == "menu" {
            let destinationVC = segue.destination as! MenuPickerVC
            MenuDBController.shared.getMenuData { (items) in
                destinationVC.items = items!
            }

        } else {
            
            let destinationVC = segue.destination as! OrdersVC
    //        print(sender.tag)
            if sender == "submitNewOrder" {
            
                submitNewOrder()
                SheetDBController.shared.postData(newOrder: newOrder) {
                    print("post data")
                    
                    SheetDBController.shared.getData { (orders) in
                        destinationVC.orders = orders!
//                        let totalCup = orders?.count
//                        destinationVC.totalCupLabelOutlet.text = String(totalCup ?? 0)
                        DispatchQueue.main.async {
                            destinationVC.tableView.reloadData()
                            destinationVC.updateTotalOrderInfo()
//                            print("get data")
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
//                            print("get data")
                            destinationVC.updateTotalOrderInfo()
                        }
                                
                    }
                }
                
            } else {
                
                SheetDBController.shared.getData { (orders) in
                    destinationVC.orders = orders!
                    
                    DispatchQueue.main.async {
                        destinationVC.tableView.reloadData()
//                        print("get data")
                        destinationVC.updateTotalOrderInfo()
                    }
                                
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

        menuButtonOutlet.layer.cornerRadius = menuButtonOutlet.frame.height / 4
        addWBubbleButtonOutlet.layer.cornerRadius = menuButtonOutlet.frame.height / 4
        submitButtonOutlet.layer.cornerRadius = menuButtonOutlet.frame.height / 4
        
        MenuDBController.shared.getMenuData { (items) in
            self.items = items!
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        isNewOrder = true
        nameTextFieldOutlet.text = name
        itemTextFieldOutlet.text = item
        priceTextFieldOutlet.text = mixin == "" ? price : String( Int(price)! + 10 )
        commentTextFieldOutlet.text = comment
        addWBubbleButtonOutlet.isSelected = mixin == "" ? false : true
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

