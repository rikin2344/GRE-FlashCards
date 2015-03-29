//
//  SignIn.swift
//  UploadMonster
//
//  Created by Rikin Desai on 8/04/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import SystemConfiguration

class SignIn: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var flashcardLabel: UILabel! = UILabel()
    @IBOutlet var userName: UITextField! = UITextField()
    @IBOutlet var passWord: UITextField! = UITextField()
    @IBOutlet var logInButton: UIButton! = UIButton()
    @IBOutlet var fillUpFields: UILabel! = UILabel()
    @IBOutlet var signUpButton: UIButton! = UIButton()
    @IBOutlet weak var userView: UIImageView! = UIImageView()
    @IBOutlet weak var passView: UIImageView! = UIImageView()
    @IBOutlet weak var forgotPassword: UIButton! = UIButton()
    
    var animating = false
    var loginStatus:Bool = false
    var count = 0
    var userData = [String]()
    
    var blurEffectView:UIVisualEffectView!
    var blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    var blueColor = UIColor(red: 24/255, green: 116/255, blue: 242/255, alpha: 1.0)
    var connected = false
    
    override func viewWillAppear(animated: Bool) {
        
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let b = defaults1.objectForKey("loginStatus") as? Bool {
            loginStatus = defaults1.objectForKey("loginStatus") as Bool
        }
        if loginStatus == true {
            self.performSegueWithIdentifier("toTabBarController", sender: self)
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewDidAppear(animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flashcardLabel.backgroundColor = UIColor.clearColor()
        self.flashcardLabel.textColor = UIColor.whiteColor()
        
        
        var lineView:UIView = UIView(frame: CGRectMake(25, 248, 270, 1))
        lineView.backgroundColor = UIColor.grayColor()
        var lineView1:UIView = UIView(frame: CGRectMake(25, 298, 270, 1))
        lineView1.backgroundColor = UIColor.grayColor()
        
        changeTextFieldAppearance()
        
        self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        self.blurEffectView.frame = self.view.frame
        var vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.blurEffect)
        var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.view.frame
        
        vibrancyEffectView.addSubview(self.userName)
        vibrancyEffectView.addSubview(self.passWord)
        vibrancyEffectView.addSubview(self.userView)
        vibrancyEffectView.addSubview(self.passView)
        vibrancyEffectView.addSubview(self.logInButton)
        vibrancyEffectView.addSubview(self.fillUpFields)
        vibrancyEffectView.addSubview(self.signUpButton)
        vibrancyEffectView.addSubview(lineView)
        vibrancyEffectView.addSubview(lineView1)
        vibrancyEffectView.addSubview(self.forgotPassword)
        vibrancyEffectView.addSubview(self.flashcardLabel)
        
        
        self.blurEffectView.contentView.addSubview(vibrancyEffectView)
        self.view.addSubview(self.blurEffectView)
        
        
        if UIScreen.mainScreen().bounds.size.height >= 568 {
        }else{
            self.flashcardLabel.frame = CGRectMake(16, 20, flashcardLabel.bounds.size.width, flashcardLabel.bounds.size.height)
            self.userView.frame = CGRectMake(28, 175, userView.bounds.size.width, userView.bounds.size.height)
            self.passView.frame = CGRectMake(28, 227, passView.bounds.size.width, passView.bounds.size.height)
            self.userName.frame = CGRectMake(69, 169, userName.bounds.size.width, userName.bounds.size.height)
            self.passWord.frame = CGRectMake(69, 221, passWord.bounds.size.width, passWord.bounds.size.height)
            self.logInButton.frame = CGRectMake(28, 290, logInButton.bounds.size.width, logInButton.bounds.size.height)
            self.signUpButton.frame = CGRectMake(20, 430, signUpButton.bounds.size.width, signUpButton.bounds.size.height)
            self.forgotPassword.frame = CGRectMake(28, 330, self.forgotPassword.bounds.size.width, self.forgotPassword.bounds.size.height)
            lineView.frame = CGRectMake(28, 200, lineView.bounds.size.width, lineView.bounds.size.height)
            lineView1.frame = CGRectMake(28, 255, lineView.bounds.size.width, lineView.bounds.size.height)
        }
        self.userName.delegate = self
        self.passWord.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func changeTextFieldAppearance(){
        
        self.userName.backgroundColor = UIColor.clearColor()
        self.userName.textColor = UIColor.whiteColor()
        self.userName.layer.borderColor = UIColor.clearColor().CGColor
        self.passWord.backgroundColor = UIColor.clearColor()
        self.passWord.textColor = UIColor.whiteColor()
        self.passWord.layer.borderColor = UIColor.clearColor().CGColor
        self.logInButton.layer.cornerRadius = 5
        self.logInButton.layer.masksToBounds = true
        self.logInButton.layer.borderColor = blueColor.CGColor
        self.logInButton.layer.borderWidth = 0.8
        self.logInButton.setTitleColor(self.blueColor, forState: UIControlState.Normal)
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
    
    @IBAction func logIn(sender: AnyObject) {
        
        if (self.isConnectionAvailble() == false) {
            var alert = UIAlertController(title: "Internet Connection Not Available", message: "Cannot Log You In", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if userName.text == "" || passWord.text == "" {
                var allfields:NSArray = [self.userName, self.passWord]
                var viewShaker:AFViewShaker = AFViewShaker(viewsArray: allfields)
                viewShaker.shake()
                fillUpFields.hidden = false
            }else{
                PFUser.logInWithUsernameInBackground(userName.text, password: passWord.text){
                    (user:PFUser!, error:NSError!)->Void in
                    if ((user) != nil){
                        defaults1.setValue(true, forKey: "loginStatus")
                        defaults1.synchronize()
                        self.fillUpFields.hidden = true
                        
                        var installation:PFInstallation = PFInstallation.currentInstallation()
                        installation.addUniqueObject("Reload", forKey: "channels")
                        installation["user"] = PFUser.currentUser()
                        installation.saveInBackground()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        var alert = UIAlertController(title: "Invalid login credentials", message: "Please re-enter Username/Password", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func forgotPassword(sender: AnyObject) {
        if isConnectionAvailble() == true {
            var loginAlert:UIAlertController = UIAlertController(title: "Password Reset", message: "Reset Link will be emailed.", preferredStyle: UIAlertControllerStyle.Alert)
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Email Address"
            })
            loginAlert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields! as NSArray
                let emailTextField:UITextField = textFields.objectAtIndex(0) as UITextField
                PFUser.requestPasswordResetForEmailInBackground(emailTextField.text)
            }))
            loginAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if textField.tag == 1{
            var newLength:Int = (textField.text as NSString).length + (string as NSString).length
            var remainingChar = 4 - newLength
            if remainingChar == 0{
                var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.20, target: self, selector: "resignKeyboard:", userInfo: nil, repeats: false)
            }
        }
        return true
    }
    
    func resignKeyboard(t: NSTimer){
        self.passWord.resignFirstResponder()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField.tag == 0 {
            passWord.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}
