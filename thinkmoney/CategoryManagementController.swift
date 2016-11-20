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

class CategoryManagementController : UITableViewController {
    
    var category = Array<Account>()
    var selectedCategory: Account!
    
    @IBAction func goToSideMenu1(segue: UIStoryboardSegue) {
        
        print("Called goToSideMenu: unwind action")
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(category.count)
        
    }
    
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as UITableViewCell
        
        let object = category[indexPath.row]
        
        cell.textLabel!.text = object.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        selectedCategory = category[indexPath.row] as Account
        
        print(selectedCategory)
        
        return indexPath
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "AddNewCategory") {
            
            print("AddNewCategory")
            //            let controller = segue.destinationViewController as AddNewEntryController
            //            let specimenAnnotation = sender as SpecimenAnnotation
            //            controller.selectedAnnotation = specimenAnnotation
        } else if(segue.identifier == "CategoryEdit") {
            print("CategoryEdit")
            
            let controller = segue.destinationViewController as! CategoryInputController
            controller.category = selectedCategory
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        let categoryData = try! Realm().objects(Account).filter("account_type = 'expenses' or account_type = 'income'")
        
        category = Array(categoryData)
        
        tableView.reloadData()
    }
    
}