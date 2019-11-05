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
    
    let tweetsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTweets()
        
        tweetsRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetsRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadTweets()
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
    
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}