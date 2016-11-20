//
//  StatCell.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 28..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit

class StatCell: UITableViewCell {

    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var bar: UIImageView!
    @IBOutlet weak var barCover: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}