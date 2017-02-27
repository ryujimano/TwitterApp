//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 2/26/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.login(success: { 
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error) in
            let alert = UIAlertController(title: "An Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.show(alert, sender: nil)
        })
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
