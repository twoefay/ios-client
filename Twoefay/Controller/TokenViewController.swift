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
    
    var tokenIdentifier: NSData?
	
	var countdown=0
	var myTimer: NSTimer? = nil

    override func viewDidAppear(animated: Bool) {     
		countdown = 5
		myTimer = NSTimer(timeInterval: 5.0, target: self, selector:"countDownTick", userInfo: nil, repeats: true)
		countdownLabel.text = "\(countdown)"
	}

	func countDownTick() {
		countdown--

		if (countdown == 0) {
		   myTimer!.invalidate()
		   myTimer=nil
		}

		countdownLabel.text = "\(countdown)"
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uses the get_token function in the file MyOneTimePassword.swift
        let current_token = get_token(self.tokenIdentifier!)
        let current_password = get_password(current_token!)
        self.tokenLabel.text = current_password!
        
        // update label every 30 seconds
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
