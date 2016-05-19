//
//  LoginScreenViewController.swift
//  Twoefay
//
//  Created by Bruin OnLine on 5/5/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // this is a comment
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        
        // Get text field data
        let userEmail = userEmailField.text;
        let userPassword = passwordField.text;
        
        // Validate email + password (locally)
        // TODO: validate remotely
        let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail");
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword");
        
        if (userEmailStored == userEmail) {
            if (userPasswordStored == userPassword) {
                // Login Successful
                NSUserDefaults.standardUserDefaults().setBool(true, forKey:"isUerLoggedIn");
                NSUserDefaults.standardUserDefaults().synchronize();
                // self.dismissViewControllerAnimated(true, completion:nil);
                performSegueWithIdentifier("verifiedLoginSegue", sender: self);
            }
        }
        else {
            displayAlert("Invalid username or password");
            return;
        }
    }
    
    // Display alert with message userMessage
    func displayAlert(userMessage:String) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }

}
