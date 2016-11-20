//
//  WhooingWebController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 8..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class WhooingWebController : UIViewController{
    
    @IBOutlet weak var whooingWeb: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        whooingAuth()
    }
 
    @IBAction func saveWhooingData(sender: AnyObject) {
        
        if (whooingWeb.request?.URLString)! =~ "pin=\\d" {
            
            let pinUrl = NSURL(string: (whooingWeb.request?.URLString)!)
            
            var queryStrings = [String: String]()
            if let query = pinUrl?.query {
                for qs in query.componentsSeparatedByString("&") {
                    // Get the parameter name
                    let key = qs.componentsSeparatedByString("=")[0]
                    // Get the parameter value
                    var value = qs.componentsSeparatedByString("=")[1]
                    value = value.stringByReplacingOccurrencesOfString("+", withString: " ")
                    value = value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    
                    queryStrings[key] = value
                }
            }
            
            let whooingData = Whooing()
            
            whooingData.pin = queryStrings["pin"]!
            whooingData.token = queryStrings["token"]!
            
            WhooingHelper.sharedInstance().getAccessToken(whooingData.pin, token: whooingData.token, onCompletion: { json in
                
                print(json)
                
                whooingData.token_secret = json["token_secret"].stringValue
                whooingData.user_id = json["user_id"].stringValue
                whooingData.token = json["token"].stringValue
                
                try! Realm().write {
                    try! Realm().create(Whooing.self, value: whooingData, update: true)
                }
                
                self.performSegueWithIdentifier("userInfoSet", sender: self)
                
            })
            
        } else {
            let alert = UIAlertView()
            alert.title = "승인 요청"
            alert.message = "앱 승인이 필요합니다."
            alert.addButtonWithTitle("확인")
            alert.show()
        }
        
    }
    
    // 후잉 인증 얻어오기
    func whooingAuth() {
        
        WhooingHelper.sharedInstance().getAuth { json in
            
            let redirectUrl = "https://whooing.com/app_auth/authorize?no_register=n&token=" + json["token"].stringValue
            let requestURL = NSURL(string:redirectUrl)
            let request1 = NSURLRequest(URL: requestURL!)
            
            self.whooingWeb.scalesPageToFit = true
            self.whooingWeb.loadRequest(request1)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        print("save user data segue")
        
        
        return true
    }

}