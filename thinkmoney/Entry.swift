//
//  Entry.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 9. 29..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import RealmSwift

class Entry : Object{
    dynamic var e_id = NSUUID().UUIDString

    dynamic var section_id = ""
    dynamic var entry_id = ""
    dynamic var entry_date = ""

    dynamic var l_a_id = ""
    dynamic var l_account = ""
    dynamic var l_account_id = ""
    dynamic var l_account_type : Account!
    
    dynamic var r_a_id = ""
    dynamic var r_account = ""
    dynamic var r_account_id = ""
    dynamic var r_account_type : Account!
    
    dynamic var item = ""
    dynamic var money = 0
    dynamic var memo = ""
    
    dynamic var total = 0
    
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var register_date = NSDate()
    
    override static func primaryKey() -> String? {
        return "e_id"
    }
    
    convenience init(id: String) {
        self.init()
        self.e_id = id
    }
    
    override static func indexedProperties() -> [String] {
        return ["l_a_id", "r_a_id", "entry_id"]
    }

}