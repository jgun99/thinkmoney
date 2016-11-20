//
//  SettingController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 11. 9..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftSpinner

infix operator =~ {}
func =~(string:String, regex:String) -> Bool {
    return string.rangeOfString(regex, options: .RegularExpressionSearch) != nil
}

class SettingController: UITableViewController {
    
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var accountName: UILabel!
    
    var webView = UIWebView()
    var whooingArray = Array<Whooing>()
    var whooingCurrent: Whooing!
    
    @IBAction func dataSync(sender: AnyObject) {
    
        if whooingCurrent == nil {
            let alert = UIAlertView()
            alert.title = "Whooing 연동"
            alert.message = "Whooing 연동정보가 없습니다."
            alert.addButtonWithTitle("확인")
            alert.show()
        } else {
            
            SwiftSpinner.show("data sync")
            
            WhooingHelper.sharedInstance().whooingDataSync({ json in
                
            
                SwiftSpinner.hide()
            })
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("whooing count \(whooingArray.count)")
//        
//        if whooingArray.count > 0 {
//            whooingCurrent = whooingArray.first
//            
//        }
//        
//        
//        settingDefaultInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath {
        
        
        return indexPath
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let whooingData = try! Realm().objects(Whooing)
    
        whooingArray = Array(whooingData)
        
        settingDefaultInfo()
        
    }
    
    func settingDefaultInfo() {
        
        if(whooingArray.count > 0) {
            WhooingHelper.sharedInstance().getUserName { json in
                
                self.accountName.text = json["username"].string!
            }
            
            whooingCurrent = whooingArray.first
            
            WhooingHelper.sharedInstance().getDefaultSection()

        }
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        print("logout");
        
        let refreshAlert = UIAlertController(title: "초기화", message: "전체 데이터 초기화를 진행하겠습니까? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "확인", style: .Default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
            print("confirm")
            
            try! Realm().write {
                try! Realm().deleteAll()
            }
                        
            self.whooingCurrent = nil
            print("whooing count \(self.whooingArray.count)")
            
            AccountService.setDefaultAccount()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "취소", style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            print("cancel")
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func whooingLogin(sender: AnyObject) {
        
//        if whooingCurrent != nil {
//            
//            return
//        }
//        
//        whooingAuth();
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        print(identifier)
        
        if identifier == "WhooingLogin" {
            
            
            if whooingCurrent != nil  {
                let alert = UIAlertView()
                alert.title = "Whooing 연동"
                alert.message = "Whooing 연동 중입니다."
                alert.addButtonWithTitle("확인")
                alert.show()
                
                return false
            }
        }
        
        return true
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "WhooingLogin" {
            
            
        }
        
    }
    
    @IBAction func userInfoSet(segue: UIStoryboardSegue) {
        
        settingDefaultInfo()
    }

}