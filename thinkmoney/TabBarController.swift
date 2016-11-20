//
//  TabBarController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 23..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBar.frame.size.height = 60 
//        tabItem1.title = "test"
//        tabItem1
        
//        print(tabItem1)
    }
    
    override func viewWillAppear(animated: Bool) {
        for item in self.tabBar.items! {
            let unselectedItem = [NSForegroundColorAttributeName: UIColor.grayColor()]
            let selectedItem = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
            item.setTitleTextAttributes(unselectedItem, forState: .Normal)
            item.setTitleTextAttributes(selectedItem, forState: .Selected)
            
            
            UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        }
    }
}