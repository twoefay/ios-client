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
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTokenField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveIdToken(sender: AnyObject) {
        // Get textfield data
        let idToken = idTokenField.text;
        var Alert: UIAlertController
        
        // Check for empty fields
        if (idToken!.isEmpty) {
            Alert = Alerts.alertPopup(AlertTitles.Error, alertMessage: AlertMessage.MissingField, alertActionTitle: AlertActionTitles.TryAgain, custom_handler: nil);
        }
        else {
            prefs.setValue(idToken, forKey: "my_id_token")
            AlamoManager.verifyTwoTokens()
            Alert = Alerts.alertPopup(AlertTitles.Success, alertMessage: AlertMessage.TokenSaved, alertActionTitle: AlertActionTitles.OK, custom_handler: alertActionHandler);
        }
        self.presentViewController(Alert, animated:true, completion:nil);
    }


    func alertActionHandler(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Can now Segue.")
        performSegueWithIdentifier("unwindToHome", sender: "")
    }
    
}
