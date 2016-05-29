//
//  AppDelegate.swift
//  Twoefay
//
//  Created by Chris Orcutt on 4/20/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //ask user for permission to send notifications
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    
    //request token from APN
    UIApplication.sharedApplication().registerForRemoteNotifications()

    
    return true
  }
  
  // receive token from APN
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    if let my_id_token = prefs.stringForKey("my_id_token") {
        print("id_token: \(my_id_token)")
        print("dev_token: \(deviceToken)")
        
        // send token to Twoefay server for registration
        Alamofire.request(.POST, "https://twoefay.xyz:8080/verify", parameters: ["id_token": my_id_token, "dev_token": deviceToken])
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
  
  // token request failed
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("error: \(error)")
    //TODO: take appropriate error action on failure
  }
    
}

