//
//  EntryListController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 14..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm
import SwiftDate
import Money


class EntryListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTitle: UILabel!
    var currentDate = NSDate()
    var selectedEntry = Entry()
    let textCellIdentifier = "EntryCell"
    
    var refreshControl = UIRefreshControl()
    
    var entryArray : Array<Entry> = []
//    var moneyArray
//    var moneyArray : Results<Entry>
    
        //.sorted("date", ascending: false).sorted("register_date", ascending: false).sorted("entry_id", ascending: false)

    var sectionDate = [String]()
    var sectionDic = [String: [Entry]]()
    
    func setSectionList() {
 
        sectionDate.removeAll()
        sectionDic.removeAll()
 
        if entryArray.count == 0 {
            return
        }
        
        for obj in entryArray {
            
            let date = obj.date.toString(DateFormat.Custom("yyyy-MM-dd"))
            
            if !sectionDate.contains(date!) {
                sectionDate.append(date!)
                sectionDic[date!] = [Entry]()
            }
            
            sectionDic[date!]!.append(obj)
        }
        
        sectionDate = sectionDate.sort({ (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
        
    }
    
    func setEntryList(value:Int) {
        let dateTo = (currentDate + (value + 1).months)
        let dateFrom = (currentDate + (value).months)
        
        currentDate = dateFrom
        
        dateTitle.text = "\(currentDate.year)년 \(currentDate.month)월"
        
        let dateTo1 = "\(dateTo.year)-\(dateTo.month)-01".toDate(DateFormat.Custom("yyyy-MM-dd"))
        let dateFrom1 = "\(dateFrom.year)-\(dateFrom.month)-01".toDate(DateFormat.Custom("yyyy-MM-dd"))
        
        let predicate = NSPredicate(format: "date >= %@ and date < %@", dateFrom1!, dateTo1!)
        
        var moneyArray = try! Realm().objects(Entry).filter(predicate).sorted("register_date", ascending: false)
    
        entryArray = Array(moneyArray)
        
        if(moneyArray.count == 0) {
            
            let sectionId = try! Realm().objects(WhooingSection).first?.section_id
            
            if(sectionId != nil && sectionId != "") {
                var finishFlag = 0
                
                WhooingHelper.sharedInstance().getEntry(sectionId!, startDate: (dateFrom1?.toString(DateFormat.Custom("yyyyMMdd")))!, endDate: (dateTo1?.toString(DateFormat.Custom("yyyyMMdd")))!, onCompletion: { json in
                
                    moneyArray = try! Realm().objects(Entry).filter(predicate).sorted("date", ascending: false).sorted("register_date", ascending: false).sorted("entry_id", ascending: false)
                    
                    self.entryArray = Array(moneyArray)
                    
                    finishFlag = 1
                })
                
                while finishFlag == 0 {
                    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
                }
            }
        }
        
    }
    
    @IBAction func nextMonth(sender: AnyObject) {
       
        setEntryList(1)
    
        setSectionList()
        
        tableView.reloadData()
    }
    @IBAction func prevMonth(sender: AnyObject) {
        
        setEntryList(-1)
        
        setSectionList()
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(RLMRealm.defaultRealm().path)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refresh(sender: AnyObject) {
        
        
        print("refresh")
        
        self.refreshControl.endRefreshing()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sectionDate.count
    }


    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionDateTemp = sectionDate[section]
        
        let date = sectionDateTemp.toDate(DateFormat.Custom("yyyy-MM-dd"))
        
        return "\(sectionDateTemp) 요일 \(date?.weekday)"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        
        let sectionDateTemp = sectionDate[section]

        let date = sectionDateTemp.toDate(DateFormat.Custom("yyyy-MM-dd"))
        
        headerCell.date.text = "\(date!.month)월\(date!.day)일 \(DateUtil.getWeekDay(date!))요일"

        let total = getTotal(sectionDic[sectionDateTemp]!)
        
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let totalWithComma = formatter.stringFromNumber(total)
        var totalPrefix = "+"
        if total < 0 {
            totalPrefix = "-"
            headerCell.date.textColor = UIColor(red: 0.937, green: 0.424, blue: 0.0, alpha: 1.0)
            headerCell.total.textColor = UIColor(red: 0.937, green: 0.424, blue: 0.0, alpha: 1.0)
        }
        
        headerCell.total.text = "\(totalWithComma!)원"
            
        return headerCell.contentView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDateTemp = sectionDate[section]

        let dateCount = sectionDic[sectionDateTemp]!.count

        return dateCount
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        let row = indexPath.row
        let section = sectionDate[indexPath.section]
        selectedEntry = sectionDic[section]![row]

        
        return indexPath
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! EntryCell
        
        let row = indexPath.row
        
        let section = sectionDate[indexPath.section]
        
        let entry = sectionDic[section]![row]
        
        let date = entry.date
        let l_account_type = entry.l_account_type
        let r_account_type = entry.r_account_type

        cell.item.text = entry.item
        
        cell.lAccount.text = l_account_type.title + "+"
        cell.rAccount.text = r_account_type.title + "-"
        
        if r_account_type.account_type == "income" {
            cell.rAccount.text = r_account_type.title
        }
        
        let money = entry.money
        var moneyPrefix = "+"
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let moneyWithComma = formatter.stringFromNumber(money)
        
        
        if l_account_type.account_type == "expenses" {
            moneyPrefix = "-"
            cell.money.textColor = UIColor(red: 0.937, green: 0.424, blue: 0.0, alpha: 1.0)
        } else {
            cell.money.textColor = UIColor(red: 0.259, green: 0.647, blue: 0.961, alpha: 1.0)
        }
        
        
        cell.money.text = "\(moneyPrefix) \(moneyWithComma!)원"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false//true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {

            let row = indexPath.row
            let section = sectionDate[indexPath.section]
            selectedEntry = sectionDic[section]![row]


            try! Realm().write{
                
                try! Realm().delete(selectedEntry)
            }
            
            
        }
        
//        tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setEntryList(0)
        
        setSectionList()
        
        tableView.reloadData()
    }
    
    
    
    func getTotal(entryArray:[Entry]) -> Int{
        
        var total = 0
        
        for obj in entryArray {
            if obj.l_account == "expenses" {
                total -= obj.money
            } else {
                total += obj.money
            }
        }
        
        return total
    }
    
    @IBAction func unwindFromAddMoney(segue: UIStoryboardSegue) {

        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "EditEntry") {
            
            print("EditEntry")
            
            let controller = segue.destinationViewController as! MoneyInputController
            controller.entry = selectedEntry
            
        } else if(segue.identifier == "CategoryEdit") {
            
            
        }
        
    }

    
    
}