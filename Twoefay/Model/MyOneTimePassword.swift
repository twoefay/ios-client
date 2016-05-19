//
//  MyOneTimePassword.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/18/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import OneTimePassword

func do_stuff_with_user_input (name: String, issuer: String, secretString: String) -> Token? {
    
    //setup
    guard let secretData = NSData(base32String: secretString)
        where secretData.length > 0 else {
            print("Invalid secret")
            return nil
    }
    
    guard let generator = Generator(
        factor: .Timer(period: 30),
        secret: secretData,
        algorithm: .SHA1,
        digits: 6) else {
            print("Invalid generator parameters")
            return nil
    }
    
    //get token
    let token = Token(name: name, issuer: issuer, generator: generator)
    
    //prepare keychain to store token
    let keychain = Keychain.sharedInstance
    //store token
    do {
        let persistentToken = try keychain.addToken(token)
        print("Saved to keychain with identifier: \(persistentToken.identifier)")
    } catch {
        print("Keychain error: \(error)")
    }
    
    return token
    
}

func get_token(identifier: NSData) -> Token? {
    
    let keychain = Keychain.sharedInstance
    do {
        let persistentToken = try keychain.persistentTokenWithIdentifier(identifier)
        print("Retrieved token: \(persistentToken!.token)")
        // Or...
        //let persistentTokens = try keychain.allPersistentTokens()
        return persistentToken?.token
    } catch {
        print("Keychain error: \(error)")
        return nil
    }
}

func get_password(token: Token) -> String? {
    let password = token.currentPassword
    return password
}

    