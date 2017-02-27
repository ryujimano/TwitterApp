//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/26/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "0NiZmAW2LWNuyX52CqRFS0AJB", consumerSecret: "Tot6xw2aqGZeXeGuafbjYuZZyyQWDK0aBV2JI03vlt1RxQMPRw")
    
    
    
    func login(success: () -> (), failure: (Error)->()) {
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterapp://oauth"), scope: nil, success: { (requestToken) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken?.token ?? "")")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            success()
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func getHomeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (_, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsFromDictionary(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func getCurrentAccount(success: @escaping (User)->(), failure: @escaping (Error)->()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task, error) in
            failure(error)
        })
    }

}
