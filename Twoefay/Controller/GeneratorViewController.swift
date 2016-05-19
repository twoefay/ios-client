//
//  GeneratorViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/19/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import OneTimePassword

class GeneratorViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var issuerField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is a comment
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitSecret(sender: AnyObject) {
        // Get textfield data
        let name = nameField.text;
        let issuer = issuerField.text;
        let secret = secretField.text;
        
        // Check for empty fields
        if (name!.isEmpty || issuer!.isEmpty || secret!.isEmpty) {
            displayAlert("All fields required")
            return;
        }
        
        // Store data (locally)
        NSUserDefaults.standardUserDefaults().setObject(name, forKey:"name")
        NSUserDefaults.standardUserDefaults().setObject(issuer, forKey:"issuer")
        NSUserDefaults.standardUserDefaults().setObject(secret, forKey:"secret")
        
        // Generate token
        guard let secretData = NSData(base32String: secret)
            where secretData.length > 0 else {
                displayAlert("Invalid secret");
                return;
        }
        
        guard let generator = Generator(
            factor: .Timer(period: 60),
            secret: secretData,
            algorithm: .SHA1,
            digits: 6) else {
                displayAlert("Invalid generator parameters");
                return;
        }
        
        let token = Token(name: name!, issuer: issuer!, generator: generator)
        
        // Store token
        let keychain = Keychain.sharedInstance
        do {
            let persistentToken = try keychain.addToken(token)
            print("Saved to keychain with identifier: \(persistentToken.identifier)")
        } catch {
            displayAlert("Keychain error");
            return;
        }
        
        // Confirm submission
        let Alert = UIAlertController(title:"Alert", message:"Token Generation Successful", preferredStyle: UIAlertControllerStyle.Alert);
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) {
            action in self.dismissViewControllerAnimated(true, completion:nil);
        }
        Alert.addAction(OK);
        
            // Pass token to next view
        
        performSegueWithIdentifier("verifiedTokenSegue", sender: self);
        
    }
    
    // Display alert with message userMessage
    func displayAlert(userMessage:String) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler:nil);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }
}
