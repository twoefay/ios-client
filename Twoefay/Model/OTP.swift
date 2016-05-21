//
//  OTP.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/18/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import Foundation
import OneTimePassword

class OTP() {
	func storeToken(name: String, issuer: String, secretString: String) -> NSData? {
		
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

	func get_password(identifier: NSData) -> String? {
		let keychain = Keychain.sharedInstance
		var token: Token
		do {
			let persistentToken = try keychain.persistentTokenWithIdentifier(identifier)
			print("Retrieved token: \(persistentToken!.token)")
			// Or...
			//let persistentTokens = try keychain.allPersistentTokens()
			token = persistentToken?.token
		} catch {
			print("Keychain error: \(error)")
			token = nil
		}
		let password = token.currentPassword
		return password
	}

		
}

