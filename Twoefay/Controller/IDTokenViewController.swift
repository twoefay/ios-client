//
//  IDTokenViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/22/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

class IDTokenViewController: UIViewController {
    
    // Label
    @IBOutlet weak var id_tokenLabel: UILabel!
    
    // POST parameters
    let headers = [ "Content-Type": "application/json" ]
    let parameters = [ "token": "23472" ]
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "45.55.160.135": .PinCertificates(
            certificates: ServerTrustPolicy.certificatesInBundle(),
            validateCertificateChain: true,
            validateHost: true
        ),
        "insecure.expired-apis.com": .DisableEvaluation
    ]
    
    // Uncommenting this wont work for some reason?
    /* let manager = Manager(
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    ) */
    var manager: Manager?
    var request: NSURLRequest?
    var response: NSHTTPURLResponse?
    var data: NSData?
    var error: NSError?
    
    // Address stuff
    var serverAddress = "https://45.55.160.135:8080"
    var getAddress = "https://45.55.160.135:8080/user/sexy"
    var getURL = NSURL()
    var acceptAddress = "https://45.55.160.135:8080/success"
    var acceptURL = NSURL()
    var declineAddress = "https://45.55.160.135:8080/failure"
    var declineURL = NSURL()
    var verifyAddress = "https://45.55.160.135:8080/verify"
    var verifyURL = NSURL()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.id_tokenLabel.text = "id_token: 23472";
        print("Current id_token: 23472")
        
        // Initialize variables
        manager = Manager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        getURL = NSURL(string: getAddress)!
        acceptURL = NSURL(string: acceptAddress)!
        declineURL = NSURL(string: declineAddress)!
        verifyURL = NSURL(string: verifyAddress)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressGet(sender: AnyObject) {
        Alamofire.request(.GET, getURL)
            .response { responseRequest, responseResponse, responseData, responseError in
                self.request = responseRequest
                self.response = responseResponse
                self.data = responseData
                self.error = responseError
        }
    }
    
    @IBAction func pressAccept(sender: AnyObject) {
        Alamofire.request(.POST, acceptURL, parameters: parameters, headers: headers)
            .responseJSON { response in
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    @IBAction func pressDecline(sender: AnyObject) {
        Alamofire.request(.POST, declineURL, parameters: parameters, headers: headers)
            .responseJSON { response in
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }

    }
    
    @IBAction func pressVerify(sender: AnyObject) {
        Alamofire.request(.POST, verifyURL, parameters: parameters, headers: headers)
            .responseJSON { response in
                print(response.response)
                print(response.data)
                print(response.result)
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}



