//
//  AssetInputController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 10. 3..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftMoment

class CategoryInputController : UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var incomeYn: UISwitch!
    @IBOutlet weak var categoryName: UITextField!
    var category : Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (category == nil) {
            title = "분류추가"
        } else {
            title = "\(category.title) 수정"
            fillTextFields()
        }
        
        incomeYn.setOn(false, animated: true)
    }
    
    func fillTextFields() {
        
        categoryName.text = category.title

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if !validateFields() {
            return false
        }
        
        if category == nil {
            addNewCategory()
        } else {
            updateCategory()
        }
        
        
        return true
    }
    
    func updateCategory() {
        
        
        try! Realm().beginWrite()
        
                try! Realm().add(self.category, update: true)
        
        
        try! Realm().commitWrite()
        
        
    }
    
    func addNewCategory() {
    
        let categoryData = try! Realm().objects(Account)
        let nextId = categoryData.max("aIndex") as Int?

        let category = Account()
        
        category.aIndex = nextId! + 1
        category.title = categoryName.text!

        if incomeYn.on {
            category.account_type = "income"
        } else {
            category.account_type = "expenses"
        }
        
        category.type = "account"
        category.category = "normal" 
        category.close_date = "2999-12-31"
    
        try! Realm().write {
            
            try! Realm().add(category)
        }
        
    }
        //
    
    func validateFields() -> Bool {
    
        if (categoryName.text!.isEmpty) {

            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled",
                preferredStyle: .Alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: {(alert : UIAlertAction!) in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                })
            
            alertController.addAction(alertAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return false
        } else {
        
            return true
        }
    }
}