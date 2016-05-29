//
//  SetupViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/29/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var idTokenField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        statusLabel.text = ""
    }
    
    @IBAction func saveIdToken(sender: AnyObject) {
        // Get textfield data
        let idToken = idTokenField.text;
        
        // Check for empty fields
        if (idToken!.isEmpty) {
            statusLabel.text = "Please Enter a Token"
            return;
        }
        
        prefs.setValue(idToken, forKey: "my_id_token")
        performSegueWithIdentifier("unwindToHome", sender: "")
    }


}
