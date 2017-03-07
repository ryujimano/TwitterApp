//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/5/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0
let distance_W_LabelHeader:CGFloat = 30.0

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    var name: String?
    var screenName: String?
    var desc: String?
    var followingCount: Int?
    var followersCount: Int?
    var tweetsCount: Int?
    var imageURL: URL?
    var backgroundURL: URL?
    
    var userTimeline: [Tweet]?

    var user: User?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        avatarView.layer.cornerRadius = 10
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 3
        avatarView.clipsToBounds = true
        
        var currentUser = User.currentUser
        
        if user != nil && user != currentUser {
            nameLabel.text = user?.name
            headerLabel.text = user?.name
            screennameLabel.text = user?.screenName
            TwitterClient.sharedInstance?.getUserTimeLine(screenName: (user?.screenName)!, success: { (tweets) in
                self.userTimeline = tweets
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
            descriptionLabel.text = user?.tagline
            followingCountLabel.text = "\(user?.followingCount ?? 0)"
            followersCountLabel.text = "\(user?.followersCount ?? 0)"
            tweetsCountLabel.text = "\(user?.tweetCount ?? 0)"
            if let url = user?.profileImageURL {
                avatarView.setImageWith(url)
            }
            if let url = user?.backgroundImageURL {
                headerImageView.setImageWith(url)
            }
        }
        else {
        TwitterClient.sharedInstance?.getUser(screenName: (currentUser?.screenName)!, success: { (user) in
            self.nameLabel.text = user.name
            self.headerLabel.text = user.name
            self.screennameLabel.text = "@\((currentUser?.screenName)!)"
            
            TwitterClient.sharedInstance?.getUserTimeLine(screenName: (currentUser?.screenName)!, success: { (tweets) in
                self.userTimeline = tweets
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
            self.descriptionLabel.text = user.tagline
            self.followingCountLabel.text = "\(user.followingCount ?? 0)"
            self.followersCountLabel.text = "\(user.followersCount ?? 0)"
            self.tweetsCountLabel.text = "\(user.tweetCount ?? 0)"
        }, failure: { (error) in
            print(error.localizedDescription)
        })
        if name == nil {
            nameLabel.text = currentUser?.name
            headerLabel.text = currentUser?.name
        }
//        else {
//            nameLabel.text = name
//            headerLabel.text = name
//        }
        
        if screenName == nil {
            screennameLabel.text = "@\((currentUser?.screenName)!)"
            
            TwitterClient.sharedInstance?.getUserTimeLine(screenName: (currentUser?.screenName)!, success: { (tweets) in
                self.userTimeline = tweets
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
//        else {
//            screennameLabel.text = screenName
//            
//            TwitterClient.sharedInstance?.getUserTimeLine(screenName: screenName!, success: { (tweets) in
//                self.userTimeline = tweets
//                self.tableView.reloadData()
//            }, failure: { (error) in
//                print(error.localizedDescription)
//            })
//        }
        
        if desc == nil {
            descriptionLabel.text = currentUser?.tagline
        }
//        else {
//            descriptionLabel.text = desc
//        }
        
        if followingCount == nil {
            followingCountLabel.text = "\(currentUser?.followingCount ?? 0)"
        }
//        else {
//            followingCountLabel.text = "\(followingCount ?? 0)"
//        }
        
        if followersCount == nil {
            followersCountLabel.text = "\(currentUser?.followersCount ?? 0)"
        }
//        else {
//            followersCountLabel.text = "\(followersCount ?? 0)"
//        }
        
            tweetsCountLabel.text = "\(currentUser?.tweetCount ?? 0)"
//        else {
//            tweetsCountLabel.text = "\(tweetsCount ?? 0)"
//        }
        
        if imageURL == nil && name != currentUser?.name {
            if let url = currentUser?.profileImageURL {
                avatarView.setImageWith(url)
            }
        }
//        else {
//            if let url = imageURL {
//                avatarView.setImageWith(url)
//            }
//        }
        
        if backgroundURL == nil && name != currentUser?.name {
            if let url = currentUser?.backgroundImageURL {
                headerImageView.setImageWith(url)
            }
        }
//        else {
//            if let url = backgroundURL {
//                headerImageView.setImageWith(url)
//            }
//        }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, tabBarController?.tabBar.frame.height ?? 0, 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTimeline?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        guard let tweet = userTimeline?[indexPath.row] else {
            return cell
        }
        
        if tweet.retweetedUser != nil {
            cell.extraView?.isHidden = false
            cell.extraImageView.image = #imageLiteral(resourceName: "iconmonstr-retweet-1-240")
            cell.extraScreenNameLabel.text = "\(tweet.retweetedUser!) Retweeted"
        }
        else {
            cell.extraView?.isHidden = true
        }
        
        cell.tweet = tweet
        
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
        if tweet.retweeted {
            cell.retweetButton.imageView?.tintColor = .green
        }
        else {
            cell.retweetButton.imageView?.tintColor = .lightGray
        }
        
        if tweet.favorited {
            cell.favoriteButton.imageView?.tintColor = .red
        }
        else {
            cell.favoriteButton.imageView?.tintColor = .lightGray
        }
        
        cell.retweetButton.tag = indexPath.row
        cell.retweetButton.addTarget(self, action: #selector(self.onRetweet(_:)), for: .touchUpInside)
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(self.onFavorite(_:)), for: .touchUpInside)
        
        
        cell.link = tweet.link
        
        cell.stackView.layer.borderWidth = 1
        cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
        //        let regex = try! NSRegularExpression(pattern: "http\\S+",options: [])
        //        let range = NSMakeRange(0, tweet.text?.characters.count ?? 0)
        //        let text = regex.stringByReplacingMatches(in: tweet.text ?? "", options: [], range: range, withTemplate: "")
        cell.tweetLabel.text = tweet.text
        
        cell.nameLabel.text = tweet.name
        if let image = tweet.profileImage {
            cell.profileView.setImageWith(image)
        }
        cell.handleLabel.text = "@\(tweet.screenName ?? "")"
        
        if let image = tweet.tweetImage {
            cell.first?.isHidden = false
            cell.tweetImageView.setImageWith(image)
        }
        else {
            cell.first?.isHidden = true
        }
        
        if let caption = tweet.caption {
            cell.second?.isHidden = false
            cell.descriptionLabel.text = caption
        }
        else {
            cell.second?.isHidden = true
        }
        
        if let link = tweet.displayLink {
            cell.third?.isHidden = false
            cell.linkButton.setTitle(link, for: .normal)
        }
        else {
            cell.third?.isHidden = true
        }
        
        
        let secondsBetween = Int(Date().timeIntervalSince(tweet.timestamp!))
        
        if secondsBetween < 60 {
            cell.dateLabel.text = "・1m"
        }
        else if secondsBetween < 3600 {
            cell.dateLabel.text = "・\(secondsBetween / 60)m"
        }
        else if secondsBetween < 86400 {
            cell.dateLabel.text = "・\(secondsBetween / 3600)h"
        }
        else {
            cell.dateLabel.text = "・\(secondsBetween / 86400)d"
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        
        // PULL DOWN -----------------
        
        if offset <= 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            
            // Hide views if scrolled super fast
            headerView.layer.zPosition = 0
            
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let alignToNameLabel = -offset + nameLabel.frame.height + nameLabel.frame.origin.y + headerView.frame.height
            
            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToNameLabel, distance_W_LabelHeader + offset_HeaderStop))
            headerLabel.updateConstraints()
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarView.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarView.bounds.height * (1.0 + avatarScaleFactor)) - avatarView.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarView.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }
                
                
            }else {
                if avatarView.layer.zPosition >= headerView.layer.zPosition{
                    headerView.layer.zPosition = 2
                }
                
            }
            
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        avatarView.layer.transform = avatarTransform
        
    }
    
    
    func onRetweet(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TweetTableViewCell
        guard let tweets = userTimeline else {
            return
        }
        let tweet = tweets[sender.tag]
        if !tweet.retweeted {
            TwitterClient.sharedInstance?.retweet(id: (tweet.id)!, success: { (tweet) in
                cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .green
                tweets[sender.tag].retweetCount = tweet.retweetCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
        else {
            TwitterClient.sharedInstance?.unretweet(id: (tweet.id)!, success: { (tweet) in
                cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .lightGray
                tweets[sender.tag].retweetCount = tweet.retweetCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func onFavorite(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TweetTableViewCell
        guard let tweets = userTimeline else {
            return
        }
        let tweet = tweets[sender.tag]
        if !tweet.favorited {
            TwitterClient.sharedInstance?.favorite(id: (tweet.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .red
                cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                tweets[sender.tag].favoritesCount = tweet.favoritesCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
        else {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .lightGray
                cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                tweets[sender.tag].favoritesCount = tweet.favoritesCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
