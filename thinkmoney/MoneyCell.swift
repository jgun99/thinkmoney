//
//  MoneyCell.swift
//  thinkmoney
//
//  Created by 박준성 on 2015. 9. 30..
//  Copyright © 2015년 tabamo. All rights reserved.
//


import UIKit

class MoneyCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var item: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}