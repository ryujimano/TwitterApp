//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/27/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var first: UIView?
    var second: UIView?
    var third: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        first = stackView.arrangedSubviews[0]
        second = stackView.arrangedSubviews[1]
        third = stackView.arrangedSubviews[2]
        
        stackView.clipsToBounds = true
        
        retweetButton.imageView?.tintColor = .lightGray
        favoriteButton.imageView?.tintColor = .lightGray
        
        profileView.layer.cornerRadius = 5
        profileView.clipsToBounds = true
        
        tweetImageView.layer.cornerRadius = 5
        tweetImageView.clipsToBounds = true
        tweetImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(_ sender: Any) {
        
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        
    }
}
