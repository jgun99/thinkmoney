//
//  WhooingHelper.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 11. 16..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoSwift

import Alamofire
import SwiftyJSON

import SwiftDate

class WhooingHelper {
    var whooingArray = try! Realm().objects(Whooing)

    var header = ""
    var whooing: Whooing!
    var app_id = "179"
    var app_secret = "6ce22dc16df74733191c6f30ffc2ad50302da695"
    
    static var instance: WhooingHelper!
    
    class func sharedInstance() -> WhooingHelper {
        self.instance = (self.instance ?? WhooingHelper())
        return self.instance
    }

    init() {
        if self.whooingArray.count != 0 {
            whooing = whooingArray[0]
            
            print(whooing)
            
        } else {
            
        
        }
    }
    
    func getHeader() -> String {
        if self.whooingArray.count != 0 {
            whooing = whooingArray[0]
    
            let signiture = "\(whooing.app_secret)|\(whooing.token_secret)".sha1()

            let timestamp = NSDate().timeIntervalSince1970
            
            let headerVal = "app_id=\(whooing.app_id),token=\(whooing.token),signiture=\(signiture),nounce=test,timestamp=\(timestamp)"
            
            return headerVal
        } else {
        
            return "NOHEADER"
        }
    }
    
    func getUserName(onCompletion: (JSON) -> Void){
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/user.json"
        
        let realm = try! Realm()
        
        let whooingUserArray = realm.objects(WhooingUser)
        
        
        if(whooingUserArray.count > 0) {
            let whooingUser = whooingUserArray[0]
            
            let json: JSON =  ["username": whooingUser.username]

            onCompletion(json as JSON)
            
            return
        }
        
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
                    var json = JSON(data)
                    
                    let user = json["results"].dictionaryObject!
                    
                    try! realm.write {
                        realm.create(WhooingUser.self, value: user, update: true)
                    }
                    
                    let userJson = JSON(user)
                    onCompletion(userJson as JSON)
                }
        }
        
    }
    
    func getAuth(onCompletion: (JSON) -> Void){
        let urlString = "https://whooing.com/app_auth/request_token"
        
        let parametersToSend = [
            "app_id": self.app_id,
            "app_secret": self.app_secret
        ]
        
        var finishFlag = 0
        
        Alamofire.request(.GET, urlString, parameters: parametersToSend)
            .responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)

                    print(json)
                    
                    onCompletion(json as JSON)
                }
                
                finishFlag = 1
        }
    }
    
    func getAccessToken(pin:String, token:String, onCompletion:(JSON) -> Void) {
        let accessTokenUrl = "https://whooing.com/app_auth/access_token"
        
        let parametersToSend = [
            "app_id": self.app_id,
            "app_secret": self.app_secret,
            "pin": pin,
            "token": token
        ]
        
        Alamofire.request(.GET, accessTokenUrl, parameters: parametersToSend)
            .responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    
                    onCompletion(json)
                }
        }
    }
    
    func getSections() {
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/sections.json_array"
        
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    
                    var json = JSON(data)
                    
                    let sections = json["results"].arrayObject!
                    
                    let realm = try! Realm()
                    
                    try! realm.write {
                        for section in sections {
                            realm.create(WhooingSection.self, value: section, update: true)
                        }
                    }
                    
                }
        }
    }
    
    func getDefaultSection() {
        
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/sections/default.json"
        
        let realm = try! Realm()
        
        let whooingSectionArray = realm.objects(WhooingSection)
        
        if whooingSectionArray.count > 0 {
            
//            self.defaultSectionId = whooingSectionArray.first!.section_id
            return
        }
        
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    var json = JSON(data)
                    
                    let defaultSection = json["results"].dictionaryObject!
                    let defaultSectionId = json["results"]["section_id"].stringValue
                    
                    try! realm.write {
                        realm.create(WhooingSection.self, value: defaultSection, update: true)
                    }
                    
                    self.getAccounts("assets", sectionId: defaultSectionId)
                    self.getAccounts("liabilities", sectionId: defaultSectionId)
                    self.getAccounts("capital", sectionId: defaultSectionId)
                    self.getAccounts("expenses", sectionId: defaultSectionId)
                    self.getAccounts("income", sectionId: defaultSectionId)
                }
        }
    }
    
    func whooingDataSync(onCompetion:(JSON) -> Void) {
        
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/sections/default.json"
        
        let realm = try! Realm()
        
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    var json = JSON(data)
                    
                    let defaultSection = json["results"].dictionaryObject!
                    let defaultSectionId = json["results"]["section_id"].stringValue
                    
                    try! realm.write {
                        realm.create(WhooingSection.self, value: defaultSection, update: true)
                    }
                    
                    self.getAccounts("assets", sectionId: defaultSectionId)
                    self.getAccounts("liabilities", sectionId: defaultSectionId)
                    self.getAccounts("capital", sectionId: defaultSectionId)
                    self.getAccounts("expenses", sectionId: defaultSectionId)
                    self.getAccounts("income", sectionId: defaultSectionId)
                    
                    let currentDate = NSDate()
                    let dateTo = (currentDate + 1.months)
                    let dateFrom = (currentDate - 11.months)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.getEntry(defaultSectionId,
                            startDate: dateFrom.toString(DateFormat.Custom("yyyyMMdd"))!,
                                endDate: dateTo.toString(DateFormat.Custom("yyyyMMdd"))!,
                            onCompletion: { json in
//                                print(json)
                        } )
                    }
                    
                    
                    onCompetion(json)
                    
                }
        }
    }
    
    func saveEntry(sectionId:String, entry:Entry, onCompletion:(JSON) -> Void) {
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/entries.json"
        
        let parameters = [
            "section_id": sectionId,
            "l_account": entry.l_account,
            "l_account_id": entry.l_account_id,
            "r_account": entry.r_account,
            "r_account_id": entry.r_account_id,
            "money": String(entry.money),
            "item": entry.item,
            "memo": entry.memo,
            "entry_date": entry.entry_date
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, headers: headers)
            .responseJSON { response in
                if let data = response.result.value {
                    
                    print(data)
                    
                    let json = JSON(data)
                    onCompletion(json)
                }
                
        }
    }
    
    func saveAccount(sectionId:String, account:Account, onCompletion:(JSON) -> Void) {
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/entries.json"
        
        let parameters = [
            "section_id": sectionId,
            "account": account.account_type,
            "title": account.title,
            "type": account.type,
            "open_date": "19000101",
            "memo": "",
            "categor":"normal"
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, headers: headers)
            .responseJSON { response in
                if let data = response.result.value {
                    
                    print(data)
                    
                    let json = JSON(data)
                    onCompletion(json)
                }
                
        }
    }
    
    
    func getAccounts(accountName:String, sectionId: String) {
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/accounts/\(accountName).json_array"
        
        Alamofire.request(.GET, urlString, parameters: ["section_id": sectionId], headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
//                    print("JSON: \(data)")
                    
                    var json = JSON(data)
                    
                    let accounts = json["results"].array!
                    
                    let realm = try! Realm()
                    
                    try! realm.write {
                        for account in accounts {
                            
                            var accountTemp = account as JSON 
                            let accountData = Account()
                            
                            accountData.title = accountTemp["title"].stringValue
                            accountData.open_date = accountTemp["open_date"].stringValue
                            accountData.account_type = accountName
                            accountData.account_id = accountTemp["account_id"].stringValue
                            accountData.memo = accountTemp["memo"].stringValue
                            accountData.category = accountTemp["category"].stringValue
                            accountData.close_date = accountTemp["close_date"].stringValue
                            accountData.type = accountTemp["type"].stringValue
                            accountData.opt_pay_account_id = accountTemp["opt_pay_account_id"].stringValue
                            accountData.opt_pay_date = accountTemp["opt_pay_date"].stringValue
                            accountData.opt_use_date = accountTemp["opt_use_date"].stringValue
                            accountData.money = accountTemp["money"].intValue
                            
//                            realm.create(Account.self, value: accountData, update: true)
                            
                            let existAccount = realm.objects(Account).filter("title = %@", accountData.title).first
                            
                            if(existAccount == nil) {
                                realm.add(accountData, update: true)
                            } else {
                                existAccount?.open_date = accountData.open_date
                                existAccount?.account_type = accountData.account_type
                                existAccount?.account_id = accountData.account_id
                            }
                        }
                    }
                    
                }
        }
    }
    
    
    
    func getEntry(sectionId: String, startDate:String, endDate:String, onCompletion:(JSON) -> Void) {
        let headers = ["X-API-KEY": self.getHeader()]
        let urlString = "https://whooing.com/api/entries.json_array"
        
        Alamofire.request(.GET, urlString, parameters: ["section_id": sectionId, "start_date":startDate, "end_date":endDate, "limit":"100"], headers: headers)
            .responseJSON { response in
                
                if let data = response.result.value {
                    
                    var json = JSON(data)
                    print(json)
                    
                    let entries = json["results"]["rows"].array!
                    
                    let realm = try! Realm()
                    
                    try! realm.write {
                        for entry in entries {
                            
                            var entryTemp = entry as JSON
                            let entryId = entryTemp["entry_id"].stringValue
                            var entryData = realm.objects(Entry).filter("entry_id = %@", entryId).first
                            
                            if entryData == nil {
                                entryData = Entry()
                            }
                            
                            entryData!.money = entryTemp["money"].intValue
                            entryData!.entry_id = entryId
                            entryData!.entry_date = entryTemp["entry_date"].stringValue
                            
                            let dateIndex = entryData!.entry_date.endIndex.advancedBy(-5)
                            let dateTemp = entryData!.entry_date.substringToIndex(dateIndex)
                            
                            
                            let dateTime = dateTemp.toDate(DateFormat.Custom("yyyyMMdd"))
                            
                            entryData!.date = dateTime!
                            entryData!.item = entryTemp["item"].stringValue
                            entryData!.memo = entryTemp["memo"].stringValue
                            entryData!.l_account = entryTemp["l_account"].stringValue
                            entryData!.l_account_id = entryTemp["l_account_id"].stringValue
                            entryData!.r_account = entryTemp["r_account"].stringValue
                            entryData!.r_account_id = entryTemp["r_account_id"].stringValue
                            
                            let lAccount = realm.objects(Account.self).filter("account_id = '" + entryData!.l_account_id  + "'").first!
                            entryData!.l_account_type = lAccount
                            entryData!.l_a_id = lAccount.a_id
                            
                            let rAccount = realm.objects(Account.self).filter("account_id = '" + entryData!.r_account_id  + "'").first!
                            entryData!.r_account_type = rAccount
                            entryData!.r_a_id = rAccount.a_id
                                                        
                            realm.add(entryData!, update: true)
                            
                            onCompletion(json)
                        }
                    }

                }
        }
    
    }
    
}