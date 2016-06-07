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
     receivedPush is true if the user navigated to this page from a current push notification
     receivedPush is false if they are viewing their login request history
     */
    var receivedPush = false
    
    /**
     manualLoginRequest is true if the user navigated to this page manually from the HomeViewController
     manualLoginRequest is false if they are viewing their login request history
     */
    var manualLoginRequest = false
    
    var thisLoginRequest: LoginRequest = LoginRequest()
    var loginRequestId: Int?
    
    let context = LAContext()
    let policy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics
    let error: NSErrorPointer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Opening Login Request Page")
        print("Received Push: \(receivedPush)")
        print("loginRequestId: \(loginRequestId)")
        
        acceptButton.tag = 0
        rejectButton.tag = 1
        
        if manualLoginRequest == true {
            thisLoginRequest = LoginRequestManager.getNewestLoginRequest()!
            statusLabel.text = "This request may be outdated"
        }
        else if receivedPush == true {
            if let newLoginRequestId = loginRequestId {
                thisLoginRequest =
                    LoginRequestManager.getLoginRequestForId(newLoginRequestId)!
            }

        }
        else {
            if let historicalLoginRequestId = loginRequestId {
                thisLoginRequest =
                    LoginRequestManager.getLoginRequestForId(historicalLoginRequestId)!
                // Hide the buttons if viewing a historical request
                acceptButton.hidden = true
                rejectButton.hidden = true
            }
        }
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
    
    @IBAction func acceptButtonTapped(sender: UIButton) {
        if context.canEvaluatePolicy(policy, error: error){
            context.evaluatePolicy(policy, localizedReason: "Pleace authenticate using TouchID"){ status, error in
                status ? self.authenticationSucceeded(sender) : self.authenticationFailed(error!)
            }
        } else {
            touchIDNotAvailable()
        }
    }
    
    @IBAction func rejectButtonTapped(sender: UIButton) {
        authenticationSucceeded(sender)
    }
    
}
