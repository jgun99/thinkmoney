//
//  AssetManagementController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 10. 4..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftMoment


class AssetManagementController : UITableViewController {
    
    var asset = Array<Account>()
    var selectedAsset: Account!
    
    @IBAction func goToSideMenu1(segue: UIStoryboardSegue) {
        
        print("Called goToSideMenu: unwind action")
        
    }
    
    override func viewDidLoad() {     
        super.viewDidLoad()
    }
    
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return asset.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("assetCell", forIndexPath: indexPath) as UITableViewCell
        
        let object = asset[indexPath.row]

        cell.textLabel!.text = object.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        selectedAsset = asset[indexPath.row] as Account
        
        print(selectedAsset)
        
        return indexPath
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "AddNewAsset") {
            
            print("AddNewAsset")
//            let controller = segue.destinationViewController as AddNewEntryController
//            let specimenAnnotation = sender as SpecimenAnnotation
//            controller.selectedAnnotation = specimenAnnotation
        } else if(segue.identifier == "AssetEdit") {
            print("AssetEdit")
            
            let controller = segue.destinationViewController as! AssetInputController
            controller.asset = selectedAsset
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
    
        let assetData = try! Realm().objects(Account).filter("account_type = 'assets' or account_type = 'liabilities'")
        asset = Array(assetData)
        
        tableView.reloadData()
    }

}