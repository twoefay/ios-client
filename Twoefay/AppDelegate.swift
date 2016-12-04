//
//  AppDelegate.swift
//  Twoefay
//
//  Created by Chris Orcutt on 4/20/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

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
        let deviceTokenString = String(deviceToken)
        prefs.setObject(deviceTokenString, forKey: "my_dev_token")
    }
  
    // token request failed
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("error: \(error)")
        //TODO: take appropriate error action on failure
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification")
        print("Attemping to save payload data")
        print("userInfo received: \(userInfo)")
        
        
        LoginRequestManager.processPushNotification(userInfo, completionHandler: { success, id in
            if success == true {
                print("processPushNotificationCompleted, got success: \(success) with id: \(id)")
                print("Attemping to navigate to Login Request page")
                self.navigateToLoginRequest(id)
            }
            else {
                print("There was some error in processPushNotification, don't navigate to the Login Request Page")
            }
        })
        
    }
    
    func navigateToLoginRequest(id: Int) {
        print("Attempting navigateToLoginRequest")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        let navigationController = self.window?.rootViewController as! UINavigationController
        navigationController.pushViewController(destinationViewController, animated: false)
        let finalDestinationViewController = storyboard.instantiateViewControllerWithIdentifier("LoginRequestViewController") as! LoginRequestViewController
        finalDestinationViewController.receivedPush = true
        finalDestinationViewController.loginRequestId = id
        navigationController.pushViewController(finalDestinationViewController, animated: false)
    }
}

