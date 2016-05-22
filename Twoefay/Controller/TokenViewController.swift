//
//  TokenViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/19/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import OneTimePassword

class TokenViewController: UIViewController {
    
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet var countDownLabel: UILabel!
    var tokenIdentifier: NSData?
    var count = 30
    
    
    func updateLabels() {
        if(count > 0) {
            count = count - 1
            countDownLabel.text = "\(count)"
        }
        else if (count == 0) {
            let current_password = OTP.getPassword(tokenIdentifier!)
            self.tokenLabel.text = current_password!
            count = 30
        }
    }

	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get all tokens 
        OTP.getAllTokens()
        
        // Uses the get_token function in the file MyOneTimePassword.swift
        let current_password = OTP.getPassword(tokenIdentifier!)
        self.tokenLabel.text = current_password!
        // update label every 30 seconds
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TokenViewController.updateLabels), userInfo: nil, repeats: true)
    }
 }
