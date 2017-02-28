//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/26/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        TwitterClient.sharedInstance?.getHomeTimeLine(success: { (tweets) in
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
        
        let rect = CGRect(x: 0, y: 0, width: 45, height: 45)
        UIGraphicsBeginImageContext(rect.size)
        #imageLiteral(resourceName: "Twitter_Logo_Blue").draw(in: rect)
        let twitterImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let twitterView = UIImageView(image: twitterImage)
        navigationItem.titleView = twitterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        
        print(tweet.text)
        
        cell.nameLabel.text = tweet.name
        if let image = tweet.profileImage {
            cell.profileView.setImageWith(image)
        }
        cell.handleLabel.text = tweet.screenName
        cell.tweetLabel.text = tweet.text
        
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
        
        if let link = tweet.link {
            cell.third?.isHidden = false
            cell.linkButton.titleLabel?.text = link
        }
        else {
            cell.third?.isHidden = true
        }
        
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        
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
