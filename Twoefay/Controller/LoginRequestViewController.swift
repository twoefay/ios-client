//
//  LoginRequestViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/5/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginRequestViewController: UIViewController {

    
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    
    /**
     receivedPush is true if the user navigated to this page from a current
     push notification or false if they are viewing their login request history
     */
    var receivedPush = false
    
    var thisLoginRequest: LoginRequest = LoginRequest()
    var loginRequestId: Int?
    
    let context = LAContext()
    let policy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics
    let error: NSErrorPointer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptButton.tag = 0
        rejectButton.tag = 1
        
        // thisLoginRequest =
        //    LoginRequestManager.getLoginRequestForId(loginRequestId!)!
        if let historicalLoginRequest = loginRequestId {
            thisLoginRequest =
                LoginRequestManager.getLoginRequestForId(historicalLoginRequest)!
        }
        else
        {
            receivedPush = true;
        }
        
        
        if receivedPush == false {
            // Display either Accept or Reject Button depending whether the
            // user had accepted or rejected the request in the past?
            
            // Alternately, just hide the buttons altogether
            acceptButton.hidden = true
            rejectButton.hidden = true
        }
        
        statusLabel.text = ""
        clientLabel.text = thisLoginRequest.clientText
        usernameLabel.text = thisLoginRequest.usernameText
        timeLabel.text = thisLoginRequest.timeText
        ipLabel.text = thisLoginRequest.ipText
        locationLabel.text = thisLoginRequest.locationText
    }
    
    func touchIDNotAvailable(){
        statusLabel.text = "TouchID not available on this device."
        print("TouchID not on this device.")
    }
    
    func alertActionHandler(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Can now Segue.")
        //performSegueWithIdentifier("unwindToAccounts", sender: "");
    }
    
    func authenticationSucceeded(sender: UIButton){
        dispatch_async(dispatch_get_main_queue()) {
            self.statusLabel.text = "Authentication successful"
            var Alert: UIAlertController    
            if sender.tag == 0 {
                AlamoManager.confirmSuccess(true)
                Alert = Alerts.alertPopup(AlertTitles.Success, alertMessage: AlertMessage.POSTSuccess, alertActionTitle: AlertActionTitles.OK, custom_handler: nil);
            }
            else {
                AlamoManager.confirmSuccess(false)
                Alert = Alerts.alertPopup(AlertTitles.Success, alertMessage: AlertMessage.POSTFailure, alertActionTitle: AlertActionTitles.OK, custom_handler: nil);
            }
            
            // Strictly Speaking, the Alert should not be presented until AlamoManager is done, but it's easier to just display the alert immediately
            self.presentViewController(Alert, animated:true, completion:nil);
        }
    }
    
    func authenticationFailed(error: NSError){
        dispatch_async(dispatch_get_main_queue()) {
            self.statusLabel.text = "Error occurred: \(error.localizedDescription)"
        }
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        if context.canEvaluatePolicy(policy, error: error){
            context.evaluatePolicy(policy, localizedReason: "Pleace authenticate using TouchID"){ status, error in
                status ? self.authenticationSucceeded(sender) : self.authenticationFailed(error!)
            }
        } else {
            touchIDNotAvailable()
        }
    }
}
