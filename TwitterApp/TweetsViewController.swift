//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/26/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    var count = 20
    var isMoreDataLoading = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        TwitterClient.sharedInstance?.getHomeTimeLine(count: count, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 320
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        let rect = CGRect(x: 0, y: 0, width: 45, height: 45)
        UIGraphicsBeginImageContext(rect.size)
        #imageLiteral(resourceName: "Twitter_Logo_Blue").draw(in: rect)
        let twitterImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let twitterView = UIImageView(image: twitterImage)
        navigationItem.titleView = twitterView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(refreshControl:UIRefreshControl) {
        count = 20
        TwitterClient.sharedInstance?.getHomeTimeLine(count: count, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                MBProgressHUD.showAdded(to: self.view, animated: true)
                if count < 200 {
                    count += 20
                }
                reload(at: count)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func onRetweet(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TweetTableViewCell
        let tweet = tweets[sender.tag]
        if !tweet.retweeted {
            TwitterClient.sharedInstance?.retweet(id: (tweet.id)!, success: { (tweet) in
                cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .green
                self.tweets[sender.tag].retweetCount = tweet.retweetCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
        else {
            TwitterClient.sharedInstance?.unretweet(id: (tweet.id)!, success: { (tweet) in
                cell.retweetCountLabel.text = "\(tweet.retweetCount)"
                cell.retweetButton.imageView?.tintColor = .lightGray
                self.tweets[sender.tag].retweetCount = tweet.retweetCount
                self.reload(at: self.count)
            }, failure: { (error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func onFavorite(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TweetTableViewCell
        let tweet = tweets[sender.tag]
        if !tweet.favorited {
            TwitterClient.sharedInstance?.favorite(id: (tweet.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .red
                cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                self.tweets[sender.tag].favoritesCount = tweet.favoritesCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
        else {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet.id)!, success: { (tweet) in
                cell.favoriteButton.imageView?.tintColor = .lightGray
                cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
                self.tweets[sender.tag].favoritesCount = tweet.favoritesCount
                self.tableView.reloadData()
            }, failure: { (error) in
                print(error.localizedDescription)
                
            })
        }
    }
    
    func reload(at count: Int) {
        TwitterClient.sharedInstance?.getHomeTimeLine(count: count, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isMoreDataLoading = false
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
        
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
