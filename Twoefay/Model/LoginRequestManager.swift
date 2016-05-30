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
    
    private class func getNewId() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        var index = defaults.integerForKey("currentIndex")
        if index == 0 {
            // We will index the Ids starting at 1 instead of starting at 0
            // The reason for this is that defaults.integerForKey() returns 0
            // When it fails to get a value. Thus, we will use 0 to represent
            // when the data set is empty.
            index = 1
        }
        else {
            index += 1
        }
        defaults.setInteger(index, forKey: "currentIndex")
        return index
    }
    
    class func processPushNotification (userInfo: [NSObject : AnyObject])                                                                                                                                                                                                                                                    {
        
        // TODO - Figure out how to extract the data from the push notification
        let clientText: String = "" //userInfo["client"]
        let usernameText: String = "" // userInfo["username"]
        let timeText: String = "" // userInfo["time"]
        let ipText: String = "" // userInfo["ip"]
        let locationText: String = "" // userInfo["location"]
        
        
        let realm = try! Realm()
        let id = getNewId()
        let myLoginRequest = LoginRequest(newId: id,
                                          client: clientText,
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
    
    class func getAllLoginRequests() -> [LoginRequest] {
        var myLoginRequests = [LoginRequest]()
        let realm = try! Realm()
        let allRequests = realm.objects(LoginRequest)
        for aRequest in allRequests {
            myLoginRequests.append(aRequest)
        }
        return myLoginRequests
    }
    
    class func getLoginRequestForId(id: Int) -> LoginRequest? {
        let realm = try! Realm()
        let result = realm.objects(LoginRequest).filter("id=\(id)")
        return result.first
    }
    
    class func loadSampleData() {
        var id = getNewId()
        let sample1 = LoginRequest(newId: id,
                                   client: "Netflix",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-17",
                                   ip: "124.234.682.531",
                                   location: "United Kingdom")
        id = getNewId()
        let sample2 = LoginRequest(newId: id,
                                   client: "Amazon",
                                   username: "user7@ucla.edu",
                                   time: "2016-05-11",
                                   ip: "394.274.62.51",
                                   location: "Paris")
        id = getNewId()
        let sample3 = LoginRequest(newId: id,
                                   client: "Google",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-22",
                                   ip: "494.214.623.1",
                                   location: "Italy")
        id = getNewId()
        let sample4 = LoginRequest(newId: id,
                                   client: "Microsoft",
                                   username: "user12@ucla.edu",
                                   time: "2016-05-23",
                                   ip: "294.241.682.5",
                                   location: "Germany")
        id = getNewId()
        let sample5 = LoginRequest(newId: id,
                                   client: "Dropbox",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-24",
                                   ip: "894.234.162.581",
                                   location: "India")
        id = getNewId()
        let sample6 = LoginRequest(newId: id,
                                   client: "Github",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-25",
                                   ip: "594.234.612.516",
                                   location: "West Florida Keys")
        id = getNewId()
        let sample7 = LoginRequest(newId: id,
                                   client: "Yahoo",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-26",
                                   ip: "94.248.612.511",
                                   location: "West Indies")
        id = getNewId()
        let sample8 = LoginRequest(newId: id,
                                   client: "Paypal",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-27",
                                   ip: "4.28.632.513",
                                   location: "West Dakota")
        id = getNewId()
        let sample9 = LoginRequest(newId: id,
                                   client: "Venmo",
                                   username: "user1@ucla.edu",
                                   time: "2016-05-28",
                                   ip: "345.28.682.951",
                                   location: "West Virginia")
        id = getNewId()
        let sample10 = LoginRequest(newId: id,
                                    client: "Microsoft",
                                    username: "user6@ucla.edu",
                                    time: "2016-35-29",
                                    ip: "87.23.672.541",
                                    location: "Houston, Texas")
        id = getNewId()
        let sample11 = LoginRequest(newId: id,
                                    client: "Google",
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
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: "currentIndex")
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}