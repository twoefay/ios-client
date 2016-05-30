//
//  LoginRequestManager.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/29/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import RealmSwift

class LoginRequestManager {
    
    class func processPushNotification (userInfo: [NSObject : AnyObject]) {
        
        // TODO - Figure out how to extract the data from the push notification
        let clientText: String = "" //userInfo["client"]
        let usernameText: String = "" // userInfo["username"]
        let timeText: String = "" // userInfo["time"]
        let ipText: String = "" // userInfo["ip"]
        let locationText: String = "" // userInfo["location"]
        
        
        let realm = try! Realm()
        let myLoginRequest = LoginRequest(client: clientText,
                                          username: usernameText,
                                          time: timeText,
                                          ip: ipText,
                                          location: locationText)
        try! realm.write {
            realm.add(myLoginRequest)
        }
    }
    
    class func numHistoricalLoginRequests () -> Int {
        let realm = try! Realm()
        return realm.objects(LoginRequest).count
    }
}