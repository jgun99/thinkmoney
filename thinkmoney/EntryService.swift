//
//  EntryService.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 24..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftSpinner

class EntryService {
    
    
    static func newEntry(entry: Entry) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(entry)
        }
        
        let sectionId = try! realm.objects(WhooingSection).first?.section_id

        if(sectionId != nil && sectionId != "") {
            SwiftSpinner.show("save entry");
            
            var finishFlag = 0
            WhooingHelper.sharedInstance().saveEntry(sectionId!, entry: entry) { json in
                
                let savedEntry = json["results"][0]
                
                let entryTemp = realm.objects(Entry).filter("e_id = %@", entry.e_id).first
                
                try! realm.write{
                    
                    entryTemp?.entry_id = savedEntry["entry_id"].stringValue
                    entryTemp?.entry_date = savedEntry["entry_date"].stringValue
                    entryTemp?.section_id = sectionId!
                    
                }
                
                finishFlag = 1
                
                SwiftSpinner.hide()
            }
            
            while finishFlag == 0 {
                NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
            }
        }
    }
    
    static func updateEntry(entry: Entry) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(entry, update: true)
        }
        
        let sectionId = try! realm.objects(WhooingSection).first?.section_id
        
//        if(sectionId != nil && sectionId != "") {
//            SwiftSpinner.show("save entry");
//         
//            
//        }
    }
    
    static func syncEntry(entry: Entry) {
        
    }
}