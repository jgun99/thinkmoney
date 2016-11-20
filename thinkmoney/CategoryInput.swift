//
//  CategoryInput.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 27..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit


class CategoryInput : UIView {
    


    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }

    convenience init () {
        self.init(frame:CGRect.zero)
        addBehavior()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        addBehavior()

    }
    
    func addBehavior (){
        print("Add all the behavior here")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        print("load keyboard")
//    }
}
