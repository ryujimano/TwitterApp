//
//  User.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/26/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageURL: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileImageURLString = dictionary["profile_image_url_https"] as? String {
            profileImageURL = URL(string: profileImageURLString)
        }
        tagline = dictionary["description"] as? String
    }
    
    class var currentUser: User? {
        get {
            return nil
        }
    }

}
