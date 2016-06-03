//
//  Alerts.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/19/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import UIKit

enum AlertTitles: String {
    case Success = "Success"
    case Error = "Error"
}


enum AlertMessage: String {
    case TokenSuccess = "Token Generation Successful"
    case TokenFailed = "Token Generation Failed"
    case TokenSaved = "Token Saved Successfully"
    case MissingToken = "Please Enter a Token"
    case MissingField = "All fields required"
    case POSTSuccess = "Website Access Allowed!"
    case POSTFailure = "Website Access Blocked!"
}

enum AlertActionTitles: String {
    case TryAgain = "Try Again"
    case OK = "OK"
}


class Alerts {
    
    class func alertPopup(alertTitle: AlertTitles, alertMessage: AlertMessage, alertActionTitle: AlertActionTitles, custom_handler: ((alertAction: UIAlertAction!) -> Void)? ) -> UIAlertController {
        
        let alert = UIAlertController(title: alertTitle.rawValue, message: alertMessage.rawValue, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: alertActionTitle.rawValue, style: UIAlertActionStyle.Cancel, handler: custom_handler)
        alert.addAction(action)
        
        return alert
    }
   
}