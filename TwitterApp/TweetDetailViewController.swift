//
//  TweetDetailViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/1/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet?
    var replyTweets: [Tweet]?
    var myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController?.tabBar.frame.height ?? 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if replyTweets == nil || replyTweets?.count == 0 {
            return 1
        }
        else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        else {
            return replyTweets?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! DetailTableViewCell
            if let tweet = tweet {
                cell = setUpTweetCell(tweet: tweet, cell: cell as! DetailTableViewCell, indexPath: indexPath)
            }
        }
        else if indexPath.row == 1 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
            if let tweet = tweet {
                cell = setUpStatsCell(tweet: tweet, cell: cell as! StatsTableViewCell, indexPath: indexPath)
            }
        }
        else if indexPath.row == 2 && indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as! ButtonsTableViewCell
            
            if let tweet = tweet {
                cell = setUpButtonsCell(tweet: tweet, cell: cell as! ButtonsTableViewCell, indexPath: indexPath)
            }

        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! TweetTableViewCell
            let replyTweet = replyTweets?[indexPath.row]
            if let replyTweet = replyTweet {
                cell = setUpReplyCell(tweet: replyTweet, cell: cell as! TweetTableViewCell, indexPath: indexPath)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setUpButtonsCell(tweet: Tweet, cell: ButtonsTableViewCell, indexPath: IndexPath) -> ButtonsTableViewCell {
        
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
        
        cell.replyButton.imageView?.tintColor = .lightGray
        
        return cell
    }
    
    func setUpStatsCell(tweet: Tweet, cell: StatsTableViewCell, indexPath: IndexPath) -> StatsTableViewCell {
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        return cell
    }
        
    func setUpTweetCell(tweet: Tweet, cell: DetailTableViewCell, indexPath: IndexPath) -> DetailTableViewCell {
        if tweet.retweetedUser != nil {
            cell.extraView?.isHidden = false
            cell.extraImageView.image = #imageLiteral(resourceName: "iconmonstr-retweet-1-240")
            cell.extraScreenNameLabel.text = "\(tweet.retweetedUser!) Retweeted"
        }
        else {
            cell.extraView?.isHidden = true
        }
        
        cell.tweet = tweet
        
        
        cell.link = tweet.link
        
        cell.stackView.layer.borderWidth = 1
        cell.stackView.layer.borderColor = UIColor.lightGray.cgColor
        cell.tweetLabel.text = tweet.text
        
        cell.nameLabel.text = tweet.name
        if let image = tweet.profileImage {
            cell.profileView.setImageWith(image)
        }
        cell.handleLabel.text = "@\(tweet.screenName!)"
        
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
        
        cell.dateLabel.textColor = .darkGray
        
        cell.dateLabel.text = tweet.timestamp?.description.substring(to: (tweet.timestamp?.description.index((tweet.timestamp?.description.endIndex)!, offsetBy: -5))!)
        
        return cell
    }
    
    func setUpReplyCell(tweet: Tweet, cell: TweetTableViewCell, indexPath: IndexPath) -> TweetTableViewCell {
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
        cell.tweetLabel.text = tweet.text
        
        cell.nameLabel.text = tweet.name
        if let image = tweet.profileImage {
            cell.profileView.setImageWith(image)
        }
        cell.handleLabel.text = "@\(tweet.screenName!)"
        
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
    
    func onRetweet(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ButtonsTableViewCell
        
        if !(tweet?.retweeted)! {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { (tweet) in
                //cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .green
                self.tweet? = tweet
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
        else {
            TwitterClient.sharedInstance?.unretweet(id: (tweet?.id)!, success: { (tweet) in
                //cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .lightGray
                self.tweet? = tweet
                self.tableView.reloadData()
                //self.reload(at: self.count)
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func onFavorite(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ButtonsTableViewCell
        
        if !(tweet?.favorited)! {
            TwitterClient.sharedInstance?.favorite(id: (tweet?.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .red
                //cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                self.tweet? = tweet
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
        else {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .lightGray
                //cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                self.tweet? = tweet
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replySegue" {
            let destination = segue.destination as! UINavigationController
            let vc = destination.topViewController as! ComposeTweetViewController
            vc.replyTweet = tweet?.screenName
            vc.replyID = tweet?.id
        }
    }

}
