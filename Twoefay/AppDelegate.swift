//
//  AppDelegate.swift
//  Twoefay
//
//  Created by Chris Orcutt on 4/20/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

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
    prefs.setObject(deviceToken, forKey: "my_dev_token")
    
    AlamoManager.verifyTwoTokens()
    
  }
  // token request failed
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("error: \(error)")
    //TODO: take appropriate error action on failure
  }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        LoginRequestManager.processPushNotification(userInfo)
    }
    
    

}

