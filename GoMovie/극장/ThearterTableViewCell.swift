//
//  ThearterTableViewCell.swift
//  GoMovie
//
//  Created by 503-03 on 27/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit

class ThearterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
