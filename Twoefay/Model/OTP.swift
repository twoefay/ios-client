//
//  OTP.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/18/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import OneTimePassword

class OTP {
    
	class func storeToken(name: String, issuer: String, secretString: String) -> NSData? {
		
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
		var tokenIdentifier: NSData?
		//store token
		do {
			let persistentToken = try keychain.addToken(token)
			tokenIdentifier = persistentToken.identifier
			print("Saved to keychain with identifier: \(persistentToken.identifier)")
		} catch {
			print("Keychain error: \(error)")
		}
		
		return tokenIdentifier
		
	}
    
    class func getAllTokens() -> Set<PersistentToken>? {
        let keychain = Keychain.sharedInstance
        var persistentTokens: Set<PersistentToken>?
        do {
            // Or...
            persistentTokens = try keychain.allPersistentTokens()
            for token in persistentTokens! {
                print(token)
            }
            return persistentTokens!
        } catch {
            print("Keychain error: \(error)")
            return nil
        }
    }

    class func getPassword(identifier: NSData) -> String? {
		let keychain = Keychain.sharedInstance
		var token: Token?
		do {
			let persistentToken = try keychain.persistentTokenWithIdentifier(identifier)
			print("Retrieved token: \(persistentToken!.token)")
			// Or...
			//let persistentTokens = try keychain.allPersistentTokens()
			token = (persistentToken?.token)!            
            let password = token!.currentPassword
            return password
		} catch {
			print("Keychain error: \(error)")
			return nil
		}
	}

    class func loadSampleData() {
        storeToken("jill@ucla.edu", issuer: "Netflix", secretString: "asdf qwer uipq ewry")
        storeToken("jane@ucla.edu", issuer: "Microsoft", secretString: "aodf q4er uipq ewry")
        storeToken("joe@ucla.edu", issuer: "Netflix", secretString: "as2f qwer u4pq ewry")
        storeToken("jack4@ucla.edu", issuer: "Netflix", secretString: "a5df qwer urpq ewry")
        storeToken("jon1@ucla.edu", issuer: "Dropbox", secretString: "as7f qwer ui8q ewry")
        storeToken("joseph6@ucla.edu", issuer: "Amazon", secretString: "a8df qwer uipq ewry")
        storeToken("jimmy1@ucla.edu", issuer: "Google", secretString: "as2f qwer uipq ewry")
    }
    
    class func clearOTPData() {
        let keychain = Keychain.sharedInstance
        let allTokens = keychain.allPersistentTokens()
        for token in allTokens {
            keychain.deletePersistentToken(token)
        }
    }
		
}

