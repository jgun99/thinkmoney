//
//  WhooingUser.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 11. 23..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift

class WhooingUser : Object{
    
    dynamic var country = ""
    dynamic var currency = ""
    dynamic var username = ""
    dynamic var user_id = ""
    dynamic var email = ""
    dynamic var language = ""
    dynamic var timezone = ""
    dynamic var image_url = ""
    
    override static func primaryKey() -> String? {
        return "user_id"
    }
    
}