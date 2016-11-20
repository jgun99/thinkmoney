//
//  LaunchScreenController.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 23..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit


class LaunchScreenController: UIViewController {
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        loadingIndicator.startAnimating()

        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
//        NSLog("Before sleep...")
//        sleep(2)
//        NSLog("After sleep...")
        
        self.controllNavigation()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func controllNavigation() -> Void {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var nextViewController = storyBoard.instantiateViewControllerWithIdentifier("EntryList") as! TabBarController

        
        self.presentViewController(nextViewController, animated: false, completion: nil)
        
    
        
    }
    
}