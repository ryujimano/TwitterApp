//
//  DetailTableViewCell.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/6/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    var link: URL?
    
    var tweet: Tweet?
    
    var first: UIView?
    var second: UIView?
    var third: UIView?
    
    
    @IBOutlet weak var extraScreenNameLabel: UILabel!
    @IBOutlet weak var extraImageView: UIImageView!
    @IBOutlet weak var cellStackView: UIStackView!
    
    var extraView: UIView?
    var mainView: UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        extraView = cellStackView.arrangedSubviews[0]
        mainView = cellStackView.arrangedSubviews[1]
        
        first = stackView.arrangedSubviews[0]
        second = stackView.arrangedSubviews[1]
        third = stackView.arrangedSubviews[2]
        
        stackView.layer.cornerRadius = 5
        stackView.clipsToBounds = true
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        
        profileView.layer.cornerRadius = 5
        profileView.clipsToBounds = true
        
        tweetImageView.layer.cornerRadius = 5
        tweetImageView.clipsToBounds = true
        tweetImageView.contentMode = .scaleAspectFill
        
        extraImageView.tintColor = .lightGray
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onLink(_ sender: Any) {
        if let link = self.link {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
}
