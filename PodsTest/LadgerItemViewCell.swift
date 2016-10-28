//
//  LadgerItemViewCell.swift
//  PodsTest
//
//  Created by ChoJae youn on 2016. 10. 25..
//  Copyright © 2016년 ChoJae youn. All rights reserved.
//

import UIKit

class LadgerItemViewCell: UITableViewCell {
    
    @IBOutlet weak var _lbNameItem: UILabel!
    @IBOutlet weak var _lbMoneyItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
