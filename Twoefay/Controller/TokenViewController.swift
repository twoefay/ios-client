//
//  TokenViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/19/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import OneTimePassword

class TokenViewController: UIViewController {
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    let keychain = Keychain.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is a comment
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printToken() {
        do {
            let persistentToken = try keychain.allPersistentTokens();
            // TRY TO PRINT TOKEN HERE
            // tokenLabel.text = TOKEN_TEXT
        }
        catch {
            tokenLabel.text = "Keychain error";
        }
    }
    
    
 }
