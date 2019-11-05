//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Jonathan Abantao on 10/23/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweetId: Int?
    
    var isFavorited: Bool = false {
        didSet {
            if isFavorited {
                favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
            }
        }
    }
    
    var isRetweeted: Bool = false {
        didSet {
            if isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 0
    }

    @IBAction func toggleFavorite(_ sender: Any) {
        if tweetId == nil {
            return
        }
        
        if isFavorited {
            unfavoriteTweet(for: tweetId!)
        } else {
            favoriteTweet(for: tweetId!)
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
        if tweetId == nil {
            return
        }
        
        if isRetweeted {
            unretweet(for: tweetId!)
        } else {
            retweet(for: tweetId!)
        }
    }
    
    private func favoriteTweet(for tweetId: Int) {
        TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
            self.setFavorite(true)
        }, failure: { (Error) in
            print("Error: \(Error)")
        })
    }
    
    private func unfavoriteTweet(for tweetId: Int) {
        TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
            self.setFavorite(false)
        }, failure: { (Error) in
            print("Error: \(Error)")
        })
    }
    
    private func retweet(for tweetId: Int) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweetFlag(true)
        }, failure: { (Error) in
            print("Error: \(Error)")
        })
    }
    
    private func unretweet(for tweetId: Int) {
        TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
            self.setRetweetFlag(false)
        }, failure: { (Error) in
            print("Error: \(Error)")
        })
    }
    
    private func setFavorite(_ favorited: Bool) {
        isFavorited = favorited
    }
    
    private func setRetweetFlag(_ isRetweeting: Bool) {
        isRetweeted = isRetweeting
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
