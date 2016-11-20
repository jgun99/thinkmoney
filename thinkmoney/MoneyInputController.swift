//
//  MoneyInputController.swift
//  ParseStarterProject
//
//  Created by 박준성 on 2015. 9. 9..
//  Copyright (c) 2015년 Parse. All rights reserved.
//


import UIKit
import ActionSheetPicker_3_0

import RealmSwift
import SwiftDate
import SwiftSpinner

class MoneyInputController: UITableViewController, UITextFieldDelegate {
    var selectedCategory: Account!
    var selectedAsset: Account!
    var entry: Entry!
    var seletedDate = NSDate()
//    let categoryArray = try! Realm().objects(Account).filter("account_type = 'expenses'")
//    let assetArray = try! Realm().objects(Account).filter("account_type = 'assets' or account_type = 'liabilities'")

    var categoryArray = Array<Account>()
    var assetArray = Array<Account>()
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAsset: UILabel!
    @IBOutlet weak var item: UITextField!
    @IBOutlet weak var memo: UITextView!
    
    
    
//    @IBOutlet weak var txtAsset: UITextField!
    
    
//    var customkeyboardView : UIView {
//        let nib = UINib(nibName: "CategoryInput", bundle: nil)
//        let objects = nib.instantiateWithOwner(self, options: nil)
//        let cView = objects[0] as! UIView
//        return cView
//    }
//
    
    func fillTextFields() {
        
        
        amount.text = String(entry.money)
        item.text = entry.item
        memo.text = entry.memo
        
        lblAsset.text = entry.r_account_type.title
        lblCategory.text = entry.l_account_type.title
        
        selectedAsset = entry.r_account_type
        selectedCategory = entry.l_account_type
        
        let date = entry.date
        
        seletedDate = date
        lblDate.text = "\(date.month)월\(date.day)일 \(DateUtil.getWeekDay(date))요일"
    }
    
    
    
    func saveEntry() {
        
        let entry = Entry()
        let itemValue = item.text
        
        let cleanArray = amount.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray
        let cleanCentString  = cleanArray.componentsJoinedByString("")
        
        entry.date = seletedDate
        entry.item = itemValue!
        entry.money = Int(cleanCentString)!
        entry.memo = memo.text
        entry.entry_date = (seletedDate.toString(DateFormat.Custom("yyyyMMdd")))!
        
        
        var account1 = selectedAsset
        var account2 = selectedCategory
        
        if selectedCategory.account_type == "income" {
            account1 = selectedCategory
            account2 = selectedAsset
        }
        
        entry.r_account_type = account1
        entry.l_account_type = account2
        
        entry.r_account = account1.account_type
        entry.r_account_id = account1.account_id
        entry.r_a_id = account1.a_id
        
        entry.l_account = account2.account_type
        entry.l_account_id = account2.account_id
        entry.l_a_id = account2.a_id
        
        EntryService.newEntry(entry)
        
    }
    
    func loadAccountData() {
        let categoryData = try! Realm().objects(Account).filter("account_type = 'expenses' or account_type = 'income'")
        let assetData = try! Realm().objects(Account).filter("account_type = 'assets' or account_type = 'liabilities'")
        
        self.categoryArray = Array(categoryData)
        self.assetArray = Array(assetData)
    }
    
    func updateEntry() {
        print("update entry")
        
        let cleanArray = amount.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray
        let cleanCentString  = cleanArray.componentsJoinedByString("")
        
      
        try! Realm().write {

            entry.date = seletedDate
            entry.item = item.text!
            entry.money = Int(cleanCentString)!
            entry.memo = memo.text
            entry.r_account_type = selectedAsset
            entry.l_account_type = selectedCategory
        
            entry.r_account = selectedAsset.account_type
            entry.r_account_id = selectedAsset.account_id
            entry.r_a_id = selectedAsset.a_id
        
            entry.l_account = selectedCategory.account_type
            entry.l_account_id = selectedCategory.account_id
            entry.l_a_id = selectedCategory.a_id
        
            entry.entry_date = (seletedDate.toString(DateFormat.Custom("yyyyMMdd")))!

        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if !validateFields() {
            return false
        }
        
        if entry == nil {
            saveEntry()
        } else {
            updateEntry()
        }
        
        return true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAccountData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadAccountData()
        amount.delegate = self;
        
//        var pasteBoardString = UIPasteboard.generalPasteboard().string
//        
//        print("pastboard \(pasteBoardString)")
//    
//        let parsed = parse(pasteBoardString!)
//        
//        print(parsed)
        
        if (entry == nil) {
            newEntryInit()
        
        } else {
        
            self.title = "\(entry.item) 수정"
            
            
            fillTextFields()
        }
////
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("dateInput:"))
        let recognizer1 = UITapGestureRecognizer(target: self, action:Selector("categoryInput:"))
        let recognizerAsset = UITapGestureRecognizer(target: self, action:Selector("assetInput:"))

        
        lblDate.userInteractionEnabled = true
        lblDate.addGestureRecognizer(recognizer)
        
        lblCategory.userInteractionEnabled = true
        lblCategory.addGestureRecognizer(recognizer1)
        
        lblAsset.userInteractionEnabled = true
        lblAsset.addGestureRecognizer(recognizerAsset)
    }
    
    func newEntryInit() {
        let date = NSDate()
        seletedDate = date
        
        lblDate.text = "\(date.month)월\(date.day)일 \(DateUtil.getWeekDay(date))요일"
        
        assetPopup()
    }
    
    func assetPopup() {
        var assets: [String] = []
        
        for asset in assetArray {
            assets.append(asset.title)
        }
        
        
        let stringPicker = ActionSheetStringPicker(title: "자산", rows: assets, initialSelection: 1, doneBlock: {
            
            picker, value, index in
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            let selected = index as! String
            self.lblAsset.text = selected
            self.selectedAsset = self.assetArray[value]
            
            self.categoryPopup()
            
            return
            
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: super.view)
        
        stringPicker.showActionSheetPicker();
    }
    
    func assetInput(sender:UITapGestureRecognizer){
        assetPopup();
        
        self.view.endEditing(true);
    }
    
    func categoryPopup() {
        var cat: [String] = []
        
        for category1 in categoryArray {
            cat.append(category1.title)
        }
        
        
        let stringPicker = ActionSheetStringPicker(title: "분류", rows: cat, initialSelection: 1, doneBlock: {
            
            picker, value, index in

            let selected = index as! String
            self.lblCategory.text = selected
            self.selectedCategory = self.categoryArray[value]
            self.amount.becomeFirstResponder()
            
            return
            
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: super.view)
        
        stringPicker.showActionSheetPicker();
    }
    
    func categoryInput(sender:UITapGestureRecognizer){

        categoryPopup()

        self.view.endEditing(true);
    }
    
    func dateInput(sender:UITapGestureRecognizer){
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: {
            picker, value, index in
            
            let date = value as! NSDate
            
            self.seletedDate = date
            self.lblDate.text = "\(date.month)월\(date.day)일 \(DateUtil.getWeekDay(date))요일"
//            self.lblDate.text = date.toString(DateFormat.Custom("yyyy-MM-dd"))
            
            return
            
            },
            cancelBlock: { ActionStringCancelBlock in return },
            origin: sender.view)

        datePicker.showActionSheetPicker()
        self.view.endEditing(true);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Create a button bar for the number pad
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        // Setup the buttons to be put in the system.
        let item = UIBarButtonItem(title: "다음", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("endEditingNow") )
  
//        let item1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("endEditingNow") )
  
        
        let toolbarButtons = [item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        textField.inputAccessoryView = keyboardDoneButtonView
        
        return true
    }
    
    func endEditingNow(){
//        self.view.endEditing(true)
        
        self.item.becomeFirstResponder()
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let cleanArray = textField.text!.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) as NSArray
        let cleanCentString  = cleanArray.componentsJoinedByString("")
        
        var centAmount:NSInteger! = Int(cleanCentString)
        
        if centAmount == nil {
            centAmount = 0
        }
        
        if string == "" {
            centAmount = centAmount / 10
        } else {
            centAmount = centAmount * 10 + Int(string)!
        }
        
        let floatValue = Double(centAmount)
        let amount = NSNumber(double:  floatValue )
        let _currencyFormatter = NSNumberFormatter()
        _currencyFormatter.numberStyle = .DecimalStyle
        
        textField.text = _currencyFormatter.stringFromNumber(amount)
        
        return false;
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder();
        return true;
    }
    
    func validateFields() -> Bool {
        
        if (selectedCategory == nil || selectedAsset == nil || amount.text!.isEmpty || item.text!.isEmpty) {
            
            let alertController = UIAlertController(title: "입력 값 확인", message: "모든 값이 입력 되어야합니다.",
                preferredStyle: .Alert)
            
            let alertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.Destructive, handler: {(alert : UIAlertAction!) in
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

