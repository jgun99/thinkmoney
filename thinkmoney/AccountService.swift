//
//  AccountService.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 28..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import RealmSwift

class AccountService {
    
    static func setDefaultAccount() {
        let account = try! Realm().objects(Account)
        
        
        if account.count == 0 {
            let wallet = Account()
            let cash = Account()
            
            wallet.money = 0
            wallet.title = "내지갑"
            wallet.category = "normal"
            wallet.type = "account"
            wallet.account_type = "asset"
            
            cash.money = 0
            cash.title = "현금"
            cash.type = "account"
            cash.category = "normal"
            cash.account_type = "asset"
        
            let realm = try! Realm()
            
            realm.beginWrite()
            
            let defaultCategories: [String] = ["식비", "교통비", "주거,통신", "생활용품", "경조사비","지식,문화","의복,미용","의료,건강","여가,유흥","세금,이자","기타비용" ]; //5
            
            for var i=0; i<defaultCategories.count; i++ {
                
                let newCategory = Account()
                
                newCategory.title = defaultCategories[i]
                
                newCategory.account_type = "expenses"
                newCategory.money = 0
                newCategory.type = "account"
                newCategory.category = "normal"
                newCategory.aIndex = i
                realm.add(newCategory)
            }
            
            
            try! realm.commitWrite()
            
            let categoryData = try! Realm().objects(Account)
            let nextId = categoryData.max("aIndex") as Int?
            
            realm.beginWrite()
            
            let defaultAsset: [String] = ["현금", "내지갑"]; //5
            
            for var i=0; i<defaultAsset.count; i++ {
                
                let newCategory = Account()
                newCategory.title = defaultAsset[i]
                
                newCategory.account_type = "assets"
                newCategory.money = 0
                newCategory.type = "account"
                newCategory.category = "normal"
                newCategory.aIndex = nextId! + i
                realm.add(newCategory)
            }
            
            try! realm.commitWrite()
            
        }
    }
    
    static func getAssetEntryList(date:NSDate) -> Array<Entry> {
        
        return Array()
    }
    
    static func getExpenseEntryList(date:NSDate) -> Array<Entry> {
     
        
        return Array()
    }
}