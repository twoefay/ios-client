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
    
    class func loadSampleData() {
        let sample1 = LoginRequest(client: "Netflix",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "124.234.682.531",
                                   location: "United Kingdom")
        let sample2 = LoginRequest(client: "Amazon",
                                   username: "user7@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "394.274.62.51",
                                   location: "Paris")
        let sample3 = LoginRequest(client: "Google",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "494.214.623.1",
                                   location: "Italy")
        let sample4 = LoginRequest(client: "Microsoft",
                                   username: "user12@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "294.241.682.5",
                                   location: "Germany")
        let sample5 = LoginRequest(client: "Dropbox",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "894.234.162.581",
                                   location: "India")
        let sample6 = LoginRequest(client: "Github",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "594.234.612.516",
                                   location: "West Florida Keys")
        let sample7 = LoginRequest(client: "Yahoo",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "94.248.612.511",
                                   location: "West Indies")
        let sample8 = LoginRequest(client: "Paypal",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "4.28.632.513",
                                   location: "West Dakota")
        let sample9 = LoginRequest(client: "Venmo",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-20",
                                   ip: "345.28.682.951",
                                   location: "West Virginia")
        let sample10 = LoginRequest(client: "Microsoft",
                                   username: "user6@ucla.edu",
                                   time: "2016-35-22",
                                   ip: "87.23.672.541",
                                   location: "Houston, Texas")
        let sample11 = LoginRequest(client: "Google",
                                   username: "user8@ucla.edu",
                                   time: "2016-05-19",
                                   ip: "77.21.628.581",
                                   location: "East Texas")
        let realm = try! Realm()
        try! realm.write {
            realm.add(sample1)
            realm.add(sample2)
            realm.add(sample3)
            realm.add(sample4)
            realm.add(sample5)
            realm.add(sample6)
            realm.add(sample7)
            realm.add(sample8)
            realm.add(sample9)
            realm.add(sample10)
            realm.add(sample11)
        }

    }
    
    class func clearRealmData() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}