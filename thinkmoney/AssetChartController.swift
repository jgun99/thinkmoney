//
//  AssetChartController.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 29..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import PNChart
import SwiftDate


class AssetChartController: UIViewController, PNChartDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var assetArray = Array<Account>()
    var liabilitiesArray = Array<Account>()

    var accountTotalDic = [String: Int]()
    var currentDate = NSDate()
    
    var assetSectionDic = [String: Array<Account>]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    override func viewWillAppear(animated: Bool) {
        
        let assetAccount = try! Realm().objects(Account).filter("account_type = 'assets'")
        let liabilitiesAccount = try! Realm().objects(Account).filter("account_type = 'liabilities'")
        
        assetArray = Array(assetAccount)
        liabilitiesArray = Array(liabilitiesAccount)
        
        getAssetTotalList()
        getLiabilitiesTotalList()
        
        
        tableView.reloadData()
    }
    
    
    func getAssetTotalList() {
        
        for accountVal in assetArray {
            let plusAsset = try! Realm().objects(Entry).filter("l_a_id = %@", accountVal.a_id)
            let minusAsset = try! Realm().objects(Entry).filter("r_a_id = %@", accountVal.a_id)            
            
            var total = 0
            
            for assetVal in plusAsset {
                
                total += assetVal.money
                
            }
            
            for assetVal in minusAsset {
                total -= assetVal.money
            }
            
            accountTotalDic[accountVal.a_id] = total
            
            try! Realm().write {
                accountVal.money = total
            }
        }
        
        
        assetSectionDic["assets"] = assetArray
        
    }
    
    func getLiabilitiesTotalList() {
        
        for accountVal in liabilitiesArray {
            let minusLiabilities = try! Realm().objects(Entry).filter("l_a_id = %@", accountVal.a_id)
            let plusLiabilities = try! Realm().objects(Entry).filter("r_a_id = %@", accountVal.a_id)
            
            var total = 0
            
            
            for liabilitiesVal in plusLiabilities {
                
                total += liabilitiesVal.money
                
            }
            
            for liabilitiesVal in minusLiabilities {
                total -= liabilitiesVal.money
            }
            
            try! Realm().write {
                accountVal.money = total
            }

        }
        
        assetSectionDic["liabilities"] = liabilitiesArray
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var assetData = assetArray
        
        switch section {
        case 0:
            assetData = assetSectionDic["assets"]!
        case 1:
            assetData = assetSectionDic["liabilities"]!
        case 2:
            assetData = Array<Account>()
        default:
            assetData = assetSectionDic["assets"]!
        }
        
        
        return assetData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AssetStatCell", forIndexPath: indexPath) as! AssetStatCell
        
        print(indexPath.section)
        var assetData = assetArray

        switch indexPath.section {
        case 0:
            assetData = assetSectionDic["assets"]!
        case 1:
            assetData = assetSectionDic["liabilities"]!
//        case 2:
//            assetData = Array<Account>()
        default:
            assetData = assetSectionDic["assets"]!
        }
        
        
        let value = assetData[indexPath.row]
        
        
        cell.assetTitle.text = value.title
        
        var total = value.money
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        
        let moneyWithComma = formatter.stringFromNumber(total)
        cell.total.text = "\(moneyWithComma!)원"
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return "test"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("AssetStatHeaderCell") as! AssetStatHeaderCell
        
        
        var title = ""

        var assetData = assetArray

        

        switch section {
        case 0:
            assetData = assetSectionDic["assets"]!
            title = "총 자산"

        case 1:
            assetData = assetSectionDic["liabilities"]!
            title = "총 부채"
        default:
            assetData = Array<Account>()
            title = "순 자산"

        }
        
        var total = getAssetTotal(assetData)

        if section == 2 {
            total = getAssetTotal(assetSectionDic["assets"]!) - getAssetTotal(assetSectionDic["liabilities"]!)
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let totalWithComma = formatter.stringFromNumber(total)
        
        headerCell.assetSectionTitle.text = title
        headerCell.total.text = "\(totalWithComma!)원"
        
        return headerCell
    }
    
    
    func getAssetTotal(array:Array<Account>) -> Int{
        
        var total = 0
        
        for obj in array {
            
            total += obj.money
        }
        
        return total
    }

}