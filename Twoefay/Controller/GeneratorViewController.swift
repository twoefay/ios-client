//
//  GeneratorViewController.swift
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

class GeneratorViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var issuerField: UITextField!
    @IBOutlet weak var secretField: UITextField!
    
    var tokenIdentifier: NSData?
    
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
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: handleQRCode))
            
            self?.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitSecret(sender: AnyObject) {
        // Get textfield data
        let name = nameField.text;
        let issuer = issuerField.text;
        let secret = secretField.text;
        
        // Check for empty fields
        if (name!.isEmpty || issuer!.isEmpty || secret!.isEmpty) {
            displayAlert("All fields required")
            return;
        }
        
        
        tokenIdentifier = storeToken(name!,issuer: issuer!,secretString: secret!)
        
        
        // Confirm submission
        // I WILL FIX THIS ALERT
        displayHandleAlert("Token Generation Successful", custom_handler: alertActionHandler);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "verifiedTokenSegue") {
            print("\nSegue: \(segue.identifier)")
            let sendToThisController = (segue.destinationViewController as! TokenViewController)
            sendToThisController.tokenIdentifier = tokenIdentifier
        }
    }
    
    
    func alertActionHandler(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Can now Segue.")
        performSegueWithIdentifier("verifiedTokenSegue", sender: tokenIdentifier);
    }
    
    func handleQRCode(alertAction: UIAlertAction!) -> Void {
        print("User Pressed OK. Take input from QR code and save it.")
        tokenIdentifier = storeToken(name!,issuer: issuer!,secretString: secret!)
        performSegueWithIdentifier("verifiedTokenSegue", sender: tokenIdentifier);
    }
    
    // Display alert with message userMessage
    func displayAlert(userMessage:String) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: nil);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }
    // Display alert with message userMessage and handler
    func displayHandleAlert(userMessage:String, custom_handler: (alertAction: UIAlertAction!) -> Void ) {
        let Alert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let OK = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default, handler: alertActionHandler);
        
        Alert.addAction(OK);
        
        self.presentViewController(Alert, animated:true, completion:nil);
    }

}
