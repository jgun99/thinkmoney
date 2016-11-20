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
import SwiftDate

class AssetInputController : UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var assetName: UITextField!

    @IBOutlet weak var assetMoney: UITextField!
    @IBOutlet weak var liabilitiesYn: UISwitch!
    
    var asset : Account!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        liabilitiesYn.setOn(false, animated: true)
        
        if (asset == nil) {
            title = "자산추가"
        } else {
            title = "\(asset.title) 수정"
            fillTextFields()
        }
        

    }
    
    func fillTextFields() {
        assetName.text = asset.title
        
        
        print(asset)
        
        
        if asset.account_type == "assets" {
            liabilitiesYn.setOn(false, animated: true)
        } else {
            liabilitiesYn.setOn(true, animated: true)
        }
//        assetMoney.text = String(asset.money)
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        if !validateFields() {
            return false
        }
        
        
        if asset == nil {
            addNewAsset()
        } else {
            updateAsset()
        }
        
        
        return true
    }
    
    func updateAsset() {
        
        
        asset.title = assetName.text!
//        asset.money = money!
        
        try! Realm().beginWrite()
        
        try! Realm().add(self.asset, update: true)
        
        try! Realm().commitWrite()
    }
    
    func addNewAsset() {
        
        let asset = Account()
//        let closeDate: Moment = moment("2999-12-31")!
//
        asset.title = assetName.text!
//        asset.money = money!
        asset.type = "account"
        asset.category = "normal"
        
        asset.close_date = "2999-12-31"
        
        if liabilitiesYn.on {
            asset.account_type = "liabilities"
        } else {
            asset.account_type = "assets"
        }
        
        try! Realm().write {

            try! Realm().add(asset)
        }

    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
//  
//        print("Testt")
//        
//        return true
//    }
//
//    
// 
    func validateFields() -> Bool {
        if (assetName.text!.isEmpty) {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .Alert)
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