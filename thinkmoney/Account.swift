//
//  Account.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 9. 29..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import RealmSwift
import UIKit

class Account: Object {
    dynamic var a_id = NSUUID().UUIDString
    dynamic var aIndex = 0
    dynamic var account_id = "" //= NSUUID().UUIDString
    dynamic var title = ""
    dynamic var memo = ""
    dynamic var category = ""
    dynamic var open_date = ""
    dynamic var close_date = ""
    dynamic var type = ""
    dynamic var money = 0
    dynamic var account_type = ""
    dynamic var refAccountId = ""
    dynamic var baseDate = ""
    dynamic var settlementDate = ""
    dynamic var opt_pay_account_id = ""
    dynamic var opt_pay_date = ""
    dynamic var opt_use_date = ""
//    dynamic var color = UIColor()
    
    
    override static func primaryKey() -> String? {
        return "a_id"
    }
    
    convenience init(accountId: String) {
        self.init()
        self.a_id = accountId
    }

    override static func indexedProperties() -> [String] {
        return ["account_type", "account_id", "title"]
    }
}