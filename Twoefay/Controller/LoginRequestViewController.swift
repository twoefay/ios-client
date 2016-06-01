//
//  LoginRequestViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/5/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import LocalAuthentication
import Alamofire

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
        completeServerRequest("https://twoefay.xyz/failure")
    }
    
    func authenticationSucceeded(sender: UIButton){
        dispatch_async(dispatch_get_main_queue()) {
            self.statusLabel.text = "Authentication successful"
            var url: String
            if sender.tag == 0 {
                url = "https://twoefay.xyz/success"
            }
            else {
                url = "https://twoefay.xyz/failure"
            }
            self.completeServerRequest(url)
        }
    }
    
    func completeServerRequest(url: String) {
        let prefs = NSUserDefaults.standardUserDefaults()
        if let my_id_token = prefs.stringForKey("my_id_token") {
            print(my_id_token)
            
            Alamofire.request(.POST, url, parameters: ["token": my_id_token], encoding: .JSON)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
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
