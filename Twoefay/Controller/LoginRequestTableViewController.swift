//
//  LoginRequestTableViewController.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/29/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class LoginRequestTableViewController: UITableViewController {
    
    var loginRequests: [LoginRequest] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginRequests = LoginRequestManager.getAllLoginRequests()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LoginRequestManager.numHistoricalLoginRequests()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LoginRequestCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        let aRequest = loginRequests[row]
        let serviceAndAccount = aRequest.clientText + "-" + aRequest.usernameText
        
        cell.textLabel?.text = serviceAndAccount
        cell.detailTextLabel?.text = aRequest.timeText

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        let selectedLoginRequest = loginRequests[indexPath.row]
        print("Selected Row \(indexPath.row) which corresponds to the login request with id: \(selectedLoginRequest.id)")
        let selectedLoginRequestId = selectedLoginRequest.id
        performSegueWithIdentifier("viewHistoricalLoginRequestSegue", sender: selectedLoginRequestId)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let loginRequestId = sender as! Int
        let destinationViewController = segue.destinationViewController as! LoginRequestViewController
        destinationViewController.loginRequestId = loginRequestId
    }
    

}
