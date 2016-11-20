//
//  EntryCell.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 12. 14..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit

class EntryCell: UITableViewCell {
    
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var rAccount: UILabel!
    @IBOutlet weak var lAccount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}