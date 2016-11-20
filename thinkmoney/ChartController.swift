//
//  ChartController.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 17..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import PNChart
import UIKit
import RealmSwift
import SwiftDate


class ChartController: UIViewController, PNChartDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var prevMonthBtn: UIBarButtonItem!
    
    @IBOutlet weak var nextMonthBtn: UIBarButtonItem!
    
    var currentDate = NSDate()

    var accountTotalDic = [String: Int]()
    var accountArray = Array<Account>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        drawExpenseChart("ex", month: 0)
        
        let prevMonth = (currentDate - 1.months)
        let nextMonth = (currentDate + 1.months)
        
        prevMonthBtn.title = "< \(prevMonth.month)월"
        nextMonthBtn.title = "\(nextMonth.month)월 >"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextMonth(sender: AnyObject) {
    }
    @IBAction func prevMonth(sender: AnyObject) {
    }
    
    
    func drawExpenseChart(accounType:String, month:Int) {
        let dateTo = (currentDate + (month + 1).months)
        let dateFrom = (currentDate + (month).months)
        
        currentDate = dateFrom
        
//        dateTitle.text = "\(currentDate.year)년 \(currentDate.month)월"
        
        let dateTo1 = "\(dateTo.year)-\(dateTo.month)-01".toDate(DateFormat.Custom("yyyy-MM-dd"))
        let dateFrom1 = "\(dateFrom.year)-\(dateFrom.month)-01".toDate(DateFormat.Custom("yyyy-MM-dd"))
        
        
//        let predicate = NSPredicate(format: "account_type = 'expenses' and date >= %@ and date < %@", dateFrom1!, dateTo1!)
        
        
        let array = NSMutableArray()
        
        for accountVal in accountArray {
            let entry = try! Realm().objects(Entry).filter("l_a_id = %@ and date >= %@ and date < %@", accountVal.a_id, dateFrom1!, dateTo1! )
        
            
            if entry.count == 0 {
                continue
            }
            
            var total = 0
            
            for entryVal in entry {
                total += entryVal.money
            }
            
            accountTotalDic[accountVal.a_id] = total
            
            var item = PNPieChartDataItem(value: CGFloat(total), color: getRandomColor(), description: accountVal.title)
        
            array.addObject(item)
        }
        
        var chart = PNPieChart(frame: CGRectMake(0, 0, 160.0, 140.0), items: array as [AnyObject])

        chart.delegate = self
        chart.descriptionTextColor = UIColor.whiteColor()
        chart.strokeChart()
        //       
//        chart.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
        //        self.view.addSubview(chart)
        chartView.addSubview(chart)

    }
    
    func getRandomColor() -> UIColor {
        var randomRed: CGFloat = CGFloat(drand48())
        var randomGreen: CGFloat = CGFloat(drand48())
        var randomBlue: CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let account = try! Realm().objects(Account).filter("account_type = 'expenses'")
        accountArray = Array(account)
        
        
        print(accountArray.count)
        drawExpenseChart("ex", month: 0)
        
        tableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accountArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("statCell", forIndexPath: indexPath) as! StatCell

        
        let accountData = accountArray[indexPath.row]
        
        var total = accountTotalDic[accountData.a_id]
        
        if total == nil {
            total = 0
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let moneyWithComma = formatter.stringFromNumber(total!)
        
        cell.accountName.text = accountData.title
        cell.total.text = "\(moneyWithComma!)원"
        
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
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
        
        let headerCell = tableView.dequeueReusableCellWithIdentifier("StatHeaderCell") as! StatHeaderCell
        
    
        let total = getExpenseTotal()
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let totalWithComma = formatter.stringFromNumber(total)
        
        headerCell.total.text = "\(totalWithComma!)원"
        
        return headerCell
    }
    
    
    func getExpenseTotal() -> Int{
        
        var total = 0
        
        for obj in accountTotalDic {
         
            total += obj.1
        }
        
        return total
    }

    
}