//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Jonathan Abantao on 11/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class UserProfileViewController: UIViewController {
    
    var user: NSDictionary!

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user!)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 0

        if self.user != nil {
            setupUserView()
        }
    }
    
    private func setupUserView() {
        bannerImageView.af_setImage(withURL: URL(string: self.user["profile_background_image_url_https"] as! String)!)
        avatarImageView.af_setImage(withURL: URL(string: self.user["profile_image_url_https"] as! String)!)
        usernameLabel.text = (self.user["name"] as! String)
        handleLabel.text = "@\(self.user["screen_name"]!)"
        highlightLabel.text = (self.user["description"] as! String)
        statusLabel.text = "\(self.user["statuses_count"]!) Tweets   \(self.user["friends_count"]!) Following   \(self.user["followers_count"]!) Followers"
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
