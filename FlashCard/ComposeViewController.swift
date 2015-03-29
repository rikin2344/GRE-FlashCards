//
//  ComposeViewController.swift
//  SwifferApp
//
//  Created by Training on 29/06/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration


class ComposeViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {

  
    @IBOutlet var sweetTextView: UITextView! = UITextView()
    @IBOutlet var charRemainingLabel: UILabel! = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        sweetTextView.layer.borderColor = UIColor.blackColor().CGColor
        sweetTextView.layer.borderWidth = 0.5
        sweetTextView.layer.cornerRadius = 5
        sweetTextView.delegate = self
        sweetTextView.becomeFirstResponder()
        self.navigationItem.title = "FlashTweet !"
        if UIScreen.mainScreen().bounds.size.height >= 568 {
        }else{
            self.sweetTextView.frame = CGRectMake(35, 30, 250, 100)
            self.charRemainingLabel.frame = CGRectMake(255, 140, 29, 21)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isConnectionAvailble()->Bool{
        var rechability:Reachability = Reachability.reachabilityForInternetConnection()
        var networkStatus:NetworkStatus = rechability.currentReachabilityStatus()
        var NotReachable:NSInteger = 0
        if networkStatus == NetworkStatus.NotReachable {
            return false
        }else{
            return true
        }
    }

    @IBAction func sendSweet() {
        if isConnectionAvailble() == false {
            var alert = UIAlertController(title: "Internet Connection Not Available", message: "Cannot Log You In", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            if sweetTextView.text == "" {
                var alert = UIAlertController(title: "Empty FlashTweet", message: "Cannot post an empty FlashTweet", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                var sweet:PFObject = PFObject(className: "Sweets")
                sweet["content"] = sweetTextView.text
                sweet["sweeter"] = PFUser.currentUser()
                sweet.saveInBackground()
                var push:PFPush = PFPush()
                push.setChannel("Reload")
                var data:NSDictionary = ["alert":"", "badge":"0", "content-available":"1","sound":0]
                push.setData(data)
                push.sendPushInBackground()
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

    func textView(textView: UITextView!,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String!) -> Bool{
            var newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingChar:Int = 140 - newLength
            charRemainingLabel.text = "\(remainingChar)"
            return (newLength >= 140) ? false : true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
