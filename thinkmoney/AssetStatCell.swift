//
//  AssetStatCell.swift
//  thinkmoney
//
//  Created by ncsoft on 2015. 12. 29..
//  Copyright © 2015년 tabamo. All rights reserved.
//

import Foundation
import UIKit

class AssetStatCell: UITableViewCell {
    

    
    @IBOutlet weak var assetTitle: UILabel!
    
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