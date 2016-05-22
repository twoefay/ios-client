//
//  TokenTableViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/22/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit
import OneTimePassword

class TokenTableViewController: UITableViewController {
    
    var tokens: Set<PersistentToken>?
    var tokensArray = [PersistentToken]()
    var count = 30
    var numRows = 0
    
    func updateLabels() {
        print(count)
        if(count > 0) {
            count = count - 1
            //countDownLabel.text = "\(count)"
        }
        else if (count == 0) {
            self.tableView.reloadData()
            count = 30
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Get all tokens
        tokens = OTP.getAllTokens()
        print(tokens)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get all tokens
        tokens = OTP.getAllTokens()
        for token in tokens! {
            tokensArray.append(token)
        }
        if let gotTokens = tokens {
            numRows = gotTokens.count
            print("There are \(numRows) accounts saved.")
        }
        else {
            "Problem!"
        }
        
        // Refresh the table every 30 seconds
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TokenViewController.updateLabels), userInfo: nil, repeats: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return numRows
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TokenCell", forIndexPath: indexPath) as! TokenCell

        // Configure the cell...
        print("cell in row")
        let row = indexPath.row
        print(row)
        let currentToken = tokensArray.removeFirst()
        let username = currentToken.token.name
        let issuer = currentToken.token.issuer
        let tokenID = currentToken.identifier
        let OneTimePass = OTP.getPassword(tokenID)
        cell.issuerLabel.text = "\(issuer):\(username)"
        cell.tokenLabel.text = OneTimePass
        
        tokensArray.append(currentToken)

        return cell
    }
 

    @IBAction func unwindToAccounts(segue:UIStoryboardSegue) {
        
    }


}
