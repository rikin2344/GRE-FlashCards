//
//  SignUp.swift
//  FlashCard
//
//  Created by Rikin Desai on 7/30/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import SystemConfiguration

class SignUp: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profilePic: UIButton! = UIButton()
    @IBOutlet var firstName: UITextField! = UITextField()
    @IBOutlet var emailField: UITextField! = UITextField()
    @IBOutlet var Username: UITextField! = UITextField()
    @IBOutlet var Password: UITextField! = UITextField()
    @IBOutlet var line1: UIView! = UIView()
    @IBOutlet var line2: UIView! = UIView()
    @IBOutlet var line3: UIView! = UIView()
    @IBOutlet var line4: UIView! = UIView()
    @IBOutlet var signUpButton: UIButton! = UIButton()
    @IBOutlet var cancelButton: UIButton! = UIButton()
    @IBOutlet var getStarted: UILabel! = UILabel()
    
    var remainingChar:Int = 0
    var userData = [String]()
    var imageFile:PFFile = PFFile()
    var collections = [UITextField]()
    var pickedImageByUser = false
    var blueColor = UIColor(red: 24/255, green: 116/255, blue: 242/255, alpha: 1.0)
    var blurEffectView: UIVisualEffectView!
    var blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)    
    var smallScreen = false
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func viewWillAppear(animated: Bool) {
        changeFieldProperty(self.firstName)
        changeFieldProperty(self.emailField)
        changeFieldProperty(self.Username)
        changeFieldProperty(self.Password)
    }
    
    func changeFieldProperty(field: UITextField){
        field.backgroundColor = UIColor.clearColor()
        field.textColor = UIColor.whiteColor()
        field.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIScreen.mainScreen().bounds.size.height >= 568 {
        }else{
            self.smallScreen = true
            self.signUpButton.frame = CGRectMake(16, 370, self.signUpButton.bounds.width, self.signUpButton.bounds.height)
            self.cancelButton.frame = CGRectMake(146, 435, 28, 28)
        }
        
        self.signUpButton.layer.cornerRadius = 5
        self.signUpButton.layer.masksToBounds = true
        self.signUpButton.layer.borderColor = blueColor.CGColor
        self.signUpButton.layer.borderWidth = 0.8
       
        self.profilePic.layer.cornerRadius = profilePic.bounds.size.width/2
        self.profilePic.layer.masksToBounds = true
        self.profilePic.layer.borderColor = UIColor.blackColor().CGColor
        self.profilePic.layer.borderWidth = 0.7

        self.emailField.delegate = self
        self.firstName.delegate = self
        self.Username.delegate = self
        self.Password.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        
        collections.append(self.firstName)
        collections.append(self.emailField)
        collections.append(self.Username)
        collections.append(self.Password)

        self.signUpButton.setTitleColor(self.blueColor, forState: UIControlState.Normal)
        
        self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
        self.blurEffectView.frame = self.view.frame
        var vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.blurEffect)
        var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.view.frame
        vibrancyEffectView.addSubview(self.getStarted)
        vibrancyEffectView.addSubview(self.profilePic)
        vibrancyEffectView.addSubview(self.firstName)
        vibrancyEffectView.addSubview(self.emailField)
        vibrancyEffectView.addSubview(self.Username)
        vibrancyEffectView.addSubview(self.Password)
        vibrancyEffectView.addSubview(self.signUpButton)
        vibrancyEffectView.addSubview(self.cancelButton)
        vibrancyEffectView.addSubview(self.line1)
        vibrancyEffectView.addSubview(self.line2)
        vibrancyEffectView.addSubview(self.line3)
        vibrancyEffectView.addSubview(self.line4)

        self.blurEffectView.contentView.addSubview(vibrancyEffectView)
        self.view.addSubview(self.blurEffectView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func selectProfilePic(sender: AnyObject) {
        var imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!){
        self.pickedImageByUser = true
        var pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        var imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
        imageFile = PFFile(data: imageData)
        self.profilePic.imageView!.image = pickedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setObject(UIImageJPEGRepresentation(pickedImage, 0.5), forKey: "savedImage")
        defaults1.synchronize()
    }

    func scaleImage(image:UIImage)->UIImage{
        var newSize:CGSize = CGSizeMake(100, 100)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, 100, 100))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
    
    @IBAction func signUp(sender: AnyObject) {
        if (self.isConnectionAvailble() == false) {
            var alert = UIAlertController(title: "Internet Connection Not Available", message: "Cannot Sign You In", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            var result = [AnyObject]()
            var result1 = [AnyObject]()
            var findUser:PFQuery = PFUser.query()
            findUser.whereKey("username", equalTo: Username.text as String)
            result = findUser.findObjects()
            var findUser1:PFQuery = PFUser.query()
            findUser1.whereKey("email", equalTo: self.emailField.text as String)
            result1 = findUser1.findObjects()
            
            if result.count > 0 {
                var alert = UIAlertController(title: "Username Conflict", message: "Please Enter a different Username.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else if (result1.count > 0){
                var alert = UIAlertController(title: "Email Address already in use", message: "Click Forgot Password to reset your account's password.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else if (firstName.text != "" && emailField.text != "" && Username.text != "" && Password.text != "" && pickedImageByUser == true){
                var passText:NSString = self.Password.text as NSString
                if passText.length >= 4{
                    var newUser:PFUser = PFUser()
                    newUser.username = Username.text
                    newUser.password = Password.text
                    newUser.email = self.emailField.text
                    newUser.signUpInBackgroundWithBlock({
                        (success:Bool!, error:NSError!)->Void in
                        
                        if (error == nil) {
                            var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            self.userData.append("Welcome")
                            self.userData.append(self.firstName.text.capitalizedString)
                            self.userData.append(self.emailField.text.capitalizedString)
                            var fullname = "Welcome, \(self.firstName.text.capitalizedString) \(self.emailField.text.capitalizedString) !"
                            self.userData.append(fullname)
                            
                            defaults1.setObject(self.userData, forKey: "userData")
                            var imageData = UIImagePNGRepresentation(self.profilePic.imageView!.image)
                            defaults1.setObject(imageData, forKey: "profilePic")
                            defaults1.synchronize()
                            self.dismissViewControllerAnimated(true, completion: nil)
                            if self.pickedImageByUser == true{
                                newUser.setObject(self.imageFile, forKey: "profilePic")
                                newUser.setObject(self.firstName.text, forKey: "firstName")
                                newUser.saveInBackground()
                                self.pickedImageByUser = false
                            }
                        }else{
                            let errorString = error.userInfo!["error"] as NSString
                            var alert = UIAlertController(title: "Sign-Up Failed", message: "\(errorString)", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
                else{
                    var alert = UIAlertController(title: "Re-enter Password", message: "The password should be at least 5 characters in length.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                if pickedImageByUser == false{
                    var allfields:NSArray = [self.profilePic]
                    var viewShaker:AFViewShaker = AFViewShaker(viewsArray: allfields)
                    viewShaker.shake()
                    
                }else{
                    var allfields:NSMutableArray = NSMutableArray()
                    for item in collections{
                        if item.text == "" {
                            allfields.addObject(item)
                        }
                    }
                    var tempArray:NSArray = allfields as NSArray
                    var viewShaker:AFViewShaker = AFViewShaker(viewsArray: tempArray)
                    viewShaker.shake()
                }
            }
        }
    }
    
    func changeTextFieldProperties(textField: UITextField){
        textField.borderStyle = UITextBorderStyle.None
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.whiteColor().CGColor
        textField.backgroundColor = UIColor.whiteColor()
        textField.textColor = UIColor.blackColor()
        textField.layer.masksToBounds = true
    }
 
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.25, animations: {
            self.view.frame = CGRectMake(0, 0, 320, 568)
        })
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField.tag == 0 {
            emailField.becomeFirstResponder()
        }else if textField.tag == 1 {
            Username.becomeFirstResponder()
        }else if textField.tag == 2{
            Password.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            if self.smallScreen == true {
                UIView.animateWithDuration(0.25, animations: {
                    self.view.frame = CGRectMake(0, 0, 320, 568)
                })
            }
        }
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField!) {
        if textField.tag == 0 {
            if self.smallScreen == true {
                UIView.animateWithDuration(0.25, animations: {
                    self.view.frame = CGRectMake(0, 0, 320, 568)
                })
            }
        }
        else if textField.tag == 2 || textField.tag == 1 || textField.tag == 3 {
            if self.smallScreen == true {
                UIView.animateWithDuration(0.25, animations: {
                    self.view.frame = CGRectMake(0, -100, 320, 568)
                })
            }
        }
    }
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        if textField.tag == 3{
            var newLength:Int = (textField.text as NSString).length + (string as NSString).length
            self.remainingChar = 4 - newLength
           if remainingChar == 0{
            var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.20, target: self, selector: "resignKeyboard:", userInfo: nil, repeats: false)
            }
        }
        return true
    }
    
    func resignKeyboard(t: NSTimer){
        self.Password.resignFirstResponder()
        if self.smallScreen == true {
            UIView.animateWithDuration(0.25, animations: {
                self.view.frame = CGRectMake(0, 0, 320, 568)
            })
        }
    }
}