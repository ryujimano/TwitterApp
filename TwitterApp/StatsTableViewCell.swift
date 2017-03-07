//
//  StatsTableViewCell.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/6/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
