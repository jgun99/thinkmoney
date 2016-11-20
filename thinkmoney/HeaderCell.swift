//
//  HeaderCell.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 16..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit

class HeaderCell: UITableViewCell {
   
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}