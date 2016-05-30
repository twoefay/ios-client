//
//  LoginRequest.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/28/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import RealmSwift

class LoginRequest: Object {
    
    dynamic var clientText: String = ""
    dynamic var usernameText: String = ""
    dynamic var timeText: String = ""
    dynamic var ipText: String = ""
    dynamic var locationText: String = ""

    
    convenience init(client: String, username: String, time: String, ip: String, location: String) {
        self.init()

        clientText = client
        usernameText = username
        timeText = time
        ipText = ip
        locationText = location
    }
}