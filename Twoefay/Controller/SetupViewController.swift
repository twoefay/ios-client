//
//  SetupViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/29/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTokenField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
        idTokenField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        AlamoManager.verifyTwoTokens()
        performSegueWithIdentifier("unwindToHome", sender: "")
    }


}
