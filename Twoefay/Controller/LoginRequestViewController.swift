//
//  LoginRequestViewController.swift
//  Twoefay
//
//  Created by Bruin OnLine on 5/5/16.
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
    
    /**
     receivedPush is true if the user navigated to this page from a current
     push notification or false if they are viewing their login request history
     */
    var recivedPush = false
    
    var thisLoginRequest: LoginRequest = LoginRequest()
    
    let context = LAContext()
    let policy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics
    let error: NSErrorPointer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recivedPush == true {
            // TODO - get info from push notification
            thisLoginRequest = LoginRequest()
        }
        else {
            // TODO - get info from history
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
        
        // this is a get
        Alamofire.request(.GET, "https://https.test.twoefay.xyz")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    print("QQQQ")
                }
        }
        
        print("QQ")
    }
    
    func authenticationSucceeded(){
        dispatch_async(dispatch_get_main_queue()) {
            self.statusLabel.text = "Authentication successful"
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
                status ? self.authenticationSucceeded() : self.authenticationFailed(error!)
            }
        } else {
            touchIDNotAvailable()
        }
    }
}
