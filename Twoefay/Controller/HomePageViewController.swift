//
//  HomePageViewController.swift
//  Twoefay
//
//  Created by Bruin OnLine on 5/5/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomePageViewController: UIViewController {

    
    @IBOutlet weak var statusLabel: UILabel!
    
    let context = LAContext()
    let policy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics
    let error: NSErrorPointer = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
    }
    
    func touchIDNotAvailable(){
        statusLabel.text = "TouchID not available on this device."
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
    
    @IBAction func buttonTapped(sender: AnyObject) {
        if context.canEvaluatePolicy(policy, error: error){
            context.evaluatePolicy(policy, localizedReason: "Pleace authenticate using TouchID"){ status, error in
                status ? self.authenticationSucceeded() : self.authenticationFailed(error!)
            }
        } else {
            touchIDNotAvailable()
        }
    }
}
