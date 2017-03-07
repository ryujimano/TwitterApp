//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Ryuji Mano on 3/5/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
