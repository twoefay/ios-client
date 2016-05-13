//
//  RegistrationPageViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/11/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class RegistrationPageViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rePasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is a comment
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitRegistration(sender: AnyObject) {
        
        // Get textfield data
        let userFirstName = firstNameField.text;
        let userLastName = lastNameField.text;
        let userEmail = emailField.text;
        let userPassword = passwordField.text;
        let userRePassword = rePasswordField.text;
        
        // Check for empty fields
        if(userFirstName!.isEmpty || userLastName!.isEmpty || userEmail!.isEmpty || userPassword!.isEmpty || userRePassword!.isEmpty) {
            // Display alert message
            displayAlert("All fields are required");
            return;
        }
        
        // Check if passwords match
        if (userPassword != userRePassword) {
            // Display alert message
            displayAlert("Passwords do not match");
            return;
        }
        
        // Store data (locally)
        // TODO: store data remotely
        NSUserDefaults.standardUserDefaults().setObject(userFirstName, forKey:"userFirstName");
        NSUserDefaults.standardUserDefaults().setObject(userLastName, forKey:"userLastName");
        NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey:"userEmail");
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"userPassword");
        NSUserDefaults.standardUserDefaults().setObject(userRePassword, forKey:"userRePassword");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        // Confirm submission
        let Alert = UIAlertController(title:"Alert", message:"Registration Successful", preferredStyle: UIAlertControllerStyle.Alert);
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) {
            action in self.dismissViewControllerAnimated(true, completion:nil);
        }
        Alert.addAction(OK);
        self.presentViewController(Alert, animated:true,completion:nil);
        
    }
    
    // Display alert with message userMessage
    func displayAlert(userMessage:String) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }
}
