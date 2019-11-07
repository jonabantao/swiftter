//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Jonathan Abantao on 10/23/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    var userData = NSDictionary()
    
    let tweetsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTweets()
        getCurrentUser()
        
        tweetsRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetsRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.loadTweets()
    }
    
    private func getCurrentUser() {
        TwitterAPICaller.client?.getCurrentUserData(success: { (currentUser: NSDictionary) in
            self.userData = currentUser
        }, failure: { (Error) in
            print("Failed to get current user")
        })
    }
    
    @objc private func loadTweets() {
        self.numberOfTweets = 20
        let homeTimeline = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": self.numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeTimeline, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetsRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Failed to retrieve tweets")
            
            self.tweetsRefreshControl.endRefreshing()
        })
    }
    
    private func loadMoreTweets() {
        let homeTimeline = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        self.numberOfTweets += 20
        let myParams = [ "count": self.numberOfTweets ]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeTimeline, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Failed to retrieve tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
        let profileImage = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: profileImage!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = self.tweetArray[indexPath.row]["text"] as? String
        cell.isFavorited = self.tweetArray[indexPath.row]["favorited"] as? Bool ?? false
        cell.isRetweeted = self.tweetArray[indexPath.row]["retweeted"] as? Bool ?? false
        cell.tweetId = self.tweetArray[indexPath.row]["id"] as? Int
    
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetNavigationSegue" {
            let tweetNavigationView = segue.destination as! UINavigationController
            let tweetViewController = tweetNavigationView.viewControllers.first as! TweetViewController
            tweetViewController.profileImageURL = self.userData["profile_image_url_https"] as! String
        }
    }
}
