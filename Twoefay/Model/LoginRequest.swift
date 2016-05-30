//
//  LoginRequest.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/28/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation

class LoginRequest {
    
    var clientText: String
    var usernameText: String
    var timeText: String
    var ipText: String
    var locationText: String
    
    init() {
        clientText = ""
        usernameText = ""
        timeText = ""
        ipText = ""
        locationText = ""
    }
    
    init(client: String, username: String, time: String, ip: String, location: String) {
        clientText = client
        usernameText = username
        timeText = time
        ipText = ip
        locationText = location
    }
}