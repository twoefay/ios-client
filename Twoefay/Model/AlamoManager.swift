//
//  AlamoManager.swift
//  Twoefay
//
//  Created by cbolids on 5/31/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamoManager {
    
    class func verifyTwoTokens () {
        print("verifyTwoTokens called")
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let my_id_token = prefs.stringForKey("my_id_token") {
            print("my_id_token was saved: \(my_id_token)")
            if let my_dev_token = prefs.stringForKey("my_dev_token") {
                print("my_dev_token was saved: \(my_dev_token)")
                // send token to Twoefay server for registration
                Alamofire.request(.POST, "https://twoefay.xyz/verify",
                    parameters: ["id_token": my_id_token, "dev_token": String(my_dev_token)],
                    encoding: .JSON)
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
            else {
                print("my_id_token was not saved")
            }
        }
        
    }
    
    class func confirmSuccess(success: Bool) {
        
        var url: String
        if success {
            url = "https://twoefay.xyz/success"
        }
        else {
            url = "https://twoefay.xyz/failure"
        }
        
        let prefs = NSUserDefaults.standardUserDefaults()
        if let my_id_token = prefs.stringForKey("my_id_token") {
            print(my_id_token)
            
            Alamofire.request(.POST, url, parameters: ["token": my_id_token], encoding: .JSON)
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
    
    class func locationFromIP(ip: String, completionHandler: ((String?) -> Void) ) {
        let url = "http://ip-api.com/json/\(ip)"
        Alamofire.request(.GET, url)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let resultjson = response.result.value {
                    print("JSON: \(resultjson)")
                    let mySwiftyJson = JSON(resultjson)
                    let city = mySwiftyJson["city"]
                    let country = mySwiftyJson["country"]
                    let location = "\(city), \(country)"
                    completionHandler(location)
                }
        }
    }


}