//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Jonathan Abantao on 11/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.becomeFirstResponder()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if tweetTextView.text.isEmpty {
            return
        }
        
        let tweetText = tweetTextView.text
        TwitterAPICaller.client?.postTweet(tweet: tweetText!, success: {
            self.dismiss(animated: true, completion: nil)
        }, failure: { (Error) in
            print("Error: \(Error)")
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
