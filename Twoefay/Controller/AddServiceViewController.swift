//
//  AddServiceViewController.swift
//  Twoefay
//
//  Created by Jonathan Woong on 5/19/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//
/*
 * QRCodeReader.swift
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
import AVFoundation
import QRCodeReader

class AddServiceViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var issuerField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    
    var tokenIdentifier: NSData?
    var QRstring = String()
    var arrayContainingParsedQRStuff = [String](); // create an empty string array
    
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeViewControllerBuilder { builder in
            builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
            builder.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(sender: AnyObject) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.dismissViewControllerAnimated(true, completion: { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .Alert
            )
            let QRstring = result.value;
            self!.parseQR(QRstring);
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: self!.handleQRCode))
            
            self?.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitSecret(sender: AnyObject) {
        // Get textfield data
        let name = nameField.text;
        let issuer = issuerField.text;
        let secret = secretField.text;
        
        var Alert: UIAlertController
        
        // Check for empty fields
        if (name!.isEmpty || issuer!.isEmpty || secret!.isEmpty) {
            Alert = Alerts.alertPopup(AlertTitles.Error, alertMessage: AlertMessage.MissingField, alertActionTitle: AlertActionTitles.OK, custom_handler: nil);
            return;
        }

        tokenIdentifier = OTP.storeToken(name!,issuer: issuer!,secretString: secret!)
        
        if (tokenIdentifier != nil) {
            Alert = Alerts.alertPopup(AlertTitles.Success, alertMessage: AlertMessage.TokenSuccess, alertActionTitle: AlertActionTitles.OK, custom_handler: alertActionHandler);
        }
        else { // Failure
            Alert = Alerts.alertPopup(AlertTitles.Error, alertMessage: AlertMessage.TokenFailed, alertActionTitle: AlertActionTitles.TryAgain, custom_handler: nil);
        }
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }
    
    func alertActionHandler(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Can now Segue.")
        performSegueWithIdentifier("unwindToAccounts", sender: tokenIdentifier);
    }
    
    func handleQRCode(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Take input from QR code and save it.")
        tokenIdentifier = OTP.storeToken(arrayContainingParsedQRStuff[0],issuer: arrayContainingParsedQRStuff[1],secretString: arrayContainingParsedQRStuff[2])
        performSegueWithIdentifier("unwindToAccounts", sender: tokenIdentifier);
    }
    
    // Display alert with message userMessage
    func displayAlert(userMessage:String) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }
    
    // Parse QRstring
    func parseQR(QRstring: String) {
        // $0 == DELIMITER
        // QRstring format: %3Aemail%40gmail.com?secret=s3cr3t&issuer=Google (of type org.iso.QRCode)
        
        var fullEmail = "";
        var issuer = "";
        var secret = "";
        
        let parts = QRstring.componentsSeparatedByString(":");
        
        if (parts.count >= 3) {
            let emailToEnd = parts[2];
            let firstSplit = emailToEnd.characters.split {$0 == "?"}.map(String.init);
            fullEmail = firstSplit[0];
            let everythingFromSecretToEnd = firstSplit[1];
            let fifthSplit = everythingFromSecretToEnd.characters.split {$0 == "&"}.map(String.init); // split ^ with & as delimiter
            let secretHalf = fifthSplit[0]; // secret=s3cr3t
            let secretSplit = secretHalf.characters.split {$0 == "="}.map(String.init); // split ^ with = as delimiter and take the right half
            secret = secretSplit[1]; // s3cr3t
            let issuerHalf = fifthSplit[1]; // issuer=Google (of type org.iso.QRCode)
            let issuerSplit = issuerHalf.characters.split {$0 == "="}.map(String.init); // split ^ with = as delimiter and take the right half
            let issuerToEnd = issuerSplit[1]; // Google (of type org.iso.QRCode)
            let remainingSplit = issuerToEnd.characters.split {$0 == " "}.map(String.init); // split ^ with space as delimiter and take the left half
            issuer = remainingSplit[0]; // Google
        }
        else {
            let firstSplit = QRstring.characters.split {$0 == "%"}.map(String.init); // split ^ with % as delimiter and take the right half
            let _3Aemail = firstSplit[1]; // 3Aemail
            let secondSplit = _3Aemail.characters.split {$0 == "A"}.map(String.init); // split ^ with A as delimiter
            let email = secondSplit[1]; // email
            let everythingFrom40ToEnd = firstSplit[2]; // 40gmail.com?secret=s3cr3t&issuer=Google (of type org.iso.QRCode)
            let thirdSplit = everythingFrom40ToEnd.characters.split {$0 == "0"}.map(String.init); // split ^ with 0 as delimiter and take the right half
            let everythingFromCarrierToEnd = thirdSplit[1]; // gmail.com?secret=s3cr3t&issuer=Google (of type org.iso.QRCode)
            let fourthSplit = everythingFromCarrierToEnd.characters.split {$0 == "?"}.map(String.init); // split ^ with ? as delimiter
            let carrier = fourthSplit[0]; // gmail.com
            let everythingFromSecretToEnd = fourthSplit[1]; // secret=s3cr3t&issuer=Google (of type org.iso.QRCode)
            let fifthSplit = everythingFromSecretToEnd.characters.split {$0 == "&"}.map(String.init); // split ^ with & as delimiter
            let secretHalf = fifthSplit[0]; // secret=s3cr3t
            let secretSplit = secretHalf.characters.split {$0 == "="}.map(String.init); // split ^ with = as delimiter and take the right half
            secret = secretSplit[1]; // s3cr3t
            let issuerHalf = fifthSplit[1]; // issuer=Google (of type org.iso.QRCode)
            let issuerSplit = issuerHalf.characters.split {$0 == "="}.map(String.init); // split ^ with = as delimiter and take the right half
            let issuerToEnd = issuerSplit[1]; // Google (of type org.iso.QRCode)
            let remainingSplit = issuerToEnd.characters.split {$0 == " "}.map(String.init); // split ^ with space as delimiter and take the left half
            issuer = remainingSplit[0]; // Google
            fullEmail = email + "@" + carrier;
        }
        
        // Store parsed data into array
        arrayContainingParsedQRStuff.insert(fullEmail, atIndex: 0);
        arrayContainingParsedQRStuff.insert(issuer, atIndex: 1);
        arrayContainingParsedQRStuff.insert(secret, atIndex: 2);
    }

}
