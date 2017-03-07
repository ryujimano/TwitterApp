//
//  ButtonsTableViewCell.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/6/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
