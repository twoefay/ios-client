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
    
    dynamic var id = 0
    dynamic var clientText: String = ""
    dynamic var usernameText: String = ""
    dynamic var timeText: String = ""
    dynamic var ipText: String = ""
    dynamic var locationText: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(newId: Int, client: String, username: String, time: String, ip: String, location: String) {
        self.init()

        id = newId
        clientText = client
        usernameText = username
        timeText = time
        ipText = ip
        locationText = location
    }
}