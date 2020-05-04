//
//  MenuPickerVC.swift
//  GroupOrders
//
//  Created by Penny Huang on 2020/5/1.
//  Copyright © 2020 Penny Huang. All rights reserved.
//

import UIKit

class MenuPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var items = [Item]()
    
    @IBOutlet weak var menuPickerOutlet: UIPickerView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFormVC", sender: nil)
        
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFormVC", sender: "submitButton")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedDrink = menuPickerOutlet.selectedRow(inComponent: 0)
        let selectedSize = menuPickerOutlet.selectedRow(inComponent: 1)
        
        if sender != nil {

            let destinationVC = segue.destination as! FormVC
            destinationVC.selectedDrink = selectedDrink
            destinationVC.selectedSize = selectedSize
            
            destinationVC.sizeSegOutlet.isEnabled = items[selectedDrink].option.count == 2 ? true : false
            
            destinationVC.updateFormOutlet()
            destinationVC.updateFormPrice()
            
        }
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return items.count
        } else  {
            let row = menuPickerOutlet.selectedRow(inComponent: 0)
//            print(row)
            if row == -1 {
                return items[0].option.count
            } else {
                return items[row].option.count
            }

        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        print(row)
        let component0Row = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            let title = items[row].drink
//            print(title)
            return title
        } else {
            let size = items[component0Row].option[row].size
//            print("drink: \(items[component0Row].drink), item option: \( items[component0Row].option[row]), size: \(items[component0Row].option[row].size)")
            return size
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
        }

    }

    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButtonOutlet.layer.cornerRadius = submitButtonOutlet.frame.height / 4
        

    }



}
