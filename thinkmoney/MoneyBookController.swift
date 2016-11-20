//
//  MoneyBookController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 9. 23..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class MoneyBookController: UITableViewController {
    
    let moneyArray = try! Realm().objects(Entry).sorted("date", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(RLMRealm.defaultRealm().path)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return moneyArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoneyCell") as! MoneyCell

        let entry = moneyArray[indexPath.row]

        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        // formatter.locale = NSLocale.currentLocale() // This is the default
        formatter.locale = NSLocale(localeIdentifier: "ko_KR")
        cell.money.text = formatter.stringFromNumber(entry.money)
        
        
        cell.date.text = String(entry.date)

//        cell.category.text = object.category?.name
        cell.item.text = entry.item
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {

        tableView.reloadData()
    }
    
    
}