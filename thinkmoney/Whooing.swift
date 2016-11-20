//
//  Whooing.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 11. 10..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift

class Whooing: Object {
    dynamic var pin = ""
    dynamic var app_id = "179"
    dynamic var app_secret = "6ce22dc16df74733191c6f30ffc2ad50302da695"
    dynamic var token = ""
    dynamic var token_secret = ""
    dynamic var user_id = ""
    
    override static func primaryKey() -> String? {
        return "app_id"
    }
    
}