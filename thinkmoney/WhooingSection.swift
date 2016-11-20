//
//  WhooingSection.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 11. 23..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift


class WhooingSection : Object {
    dynamic var section_id = ""
    dynamic var title = ""
    dynamic var memo = ""
    dynamic var currency = ""
    dynamic var isolation = ""
    dynamic var total_asset = 0.0
    dynamic var total_liabilities = 0.0
    dynamic var decimal_places = 0
    dynamic var date_format = ""
    
    override static func primaryKey() -> String? {
        return "section_id"
    }
}