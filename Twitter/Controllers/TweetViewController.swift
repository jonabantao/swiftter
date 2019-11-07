//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Jonathan Abantao on 11/4/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class TweetViewController: UIViewController, UITextViewDelegate {
    
    private let maxCharacterLimit = 140
    private var currentCharacterCount = 0 {
        didSet {
            let charactersRemaining = maxCharacterLimit - currentCharacterCount
            
            characterCountLabel.text = "\(charactersRemaining)"
        }
    }
    @IBOutlet weak var tweetTextView: RSKPlaceholderTextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tweetTextView.placeholder = "What's happpening?"
        self.tweetTextView.delegate = self
        
        self.tweetTextView.becomeFirstResponder()
    }
    
    
    @IBAction private func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func tweet(_ sender: Any) {
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count < maxCharacterLimit
    }
    
    func textViewDidChange(_ textView: UITextView) {
        currentCharacterCount = textView.text.count
    }
}
