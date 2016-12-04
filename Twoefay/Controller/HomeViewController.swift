//
//  HomeViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/5/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        addGradient()
        super.viewDidLoad()
        
        
        // check if there is an id_token saved
        let prefs = NSUserDefaults.standardUserDefaults()
        if let my_id_token = prefs.stringForKey("my_id_token") {
            print("HomePage Loaded, my_id_token: \(my_id_token)")
            
            // make sure that the dev_token stored by the server is current
            AlamoManager.verifyTwoTokens()
        }
        // since there is no id_token saved, need to get one
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("getTokenSegue", sender: "")
            })
        }
        
        
        /**
         DEVELOPMENT ONLY
         */
        let dev_mode = true
        if dev_mode == true {
            // Sample Login Requests
            LoginRequestManager.clearRealmData()
            LoginRequestManager.loadSampleData()
            // Sample Secret TOTP Accounts
            OTP.clearOTPData()
            OTP.loadSampleData()
        }
        
    }
    
     func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame.size = self.view.frame.size
        gradient.colors = [UIColor.whiteColor().CGColor,UIColor.blackColor().CGColor] //Or any colors
        
        //gradient.opacity = 0.5
        self.view.layer.insertSublayer(gradient, below: self.view.layer.sublayers?.first)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "automaticLoginRequest" {
            let destinationViewController = segue.destinationViewController as! LoginRequestViewController
            destinationViewController.receivedPush = true
        }
        if segue.identifier == "manualLoginRequest" {
            let destinationViewController = segue.destinationViewController as! LoginRequestViewController
            destinationViewController.receivedPush = false
            destinationViewController.manualLoginRequest = true
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        let Alert = Alerts.alertPopup(AlertTitles.Warning, alertMessage: AlertMessage.LogoutWarning, alertActionTitle: AlertActionTitles.OK, custom_handler: confirmLogoutHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        Alert.addAction(cancelAction)
        self.presentViewController(Alert, animated:true, completion: nil);
    }

    func confirmLogoutHandler(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Can now Segue.")
        prefs.removeObjectForKey("my_id_token")
        prefs.removeObjectForKey("my_dev_token")
        OTP.clearOTPData()
        LoginRequestManager.clearRealmData()
        performSegueWithIdentifier("getTokenSegue", sender: "")
    }
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) {
        AlamoManager.verifyTwoTokens()
    }
}
