//
//  progressView.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/25/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class progressView:UIViewController, UITextFieldDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate,SideMenuDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet var actualBlurView: UIView! = UIView()
    @IBOutlet var blurViewImageView: UIImageView! = UIImageView()
    @IBOutlet var blurView: UIView! = UIView()
    @IBOutlet var indicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    @IBOutlet var allWordsPercentCount: UILabel! = UILabel()
    @IBOutlet var highFrequencyPercentCount: UILabel! = UILabel()
    @IBOutlet var allWrdsReadCount: UILabel! = UILabel()
    @IBOutlet var hfReadCount: UILabel! = UILabel()
    @IBOutlet var welcomeLabel: UILabel! = UILabel()
    @IBOutlet var profileImageView: UIButton! = UIButton()
    @IBOutlet var progressLabel: UILabel! = UILabel()
    @IBOutlet var allWordsPlainLabel: UILabel! = UILabel()
    @IBOutlet var hfPlainLabel: UILabel! = UILabel()
    @IBOutlet var yourProgress: UILabel! = UILabel()
    @IBOutlet var stayHungry: UILabel! = UILabel()
    
    var blurEffectView:UIVisualEffectView = UIVisualEffectView()
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
    var first = false
    var first1 = false
    var allWordsReadCount = 0
    var highFrequencyWordsReadCount = 0
    var wordMeaning = ""
    var doneLoading = false
    var loginStatus = false
    var menuView3:MGFashionMenuView! = nil
    var userData = [String]()
    var greetCount = 0
    var imageData = NSData()
    var firstTimeForMorphing = false
    var sideMenu : SideMenu?
    var connect = true
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if self.connect == false {
            if isConnectionAvailble() == true {
                self.viewDidLoad()
                self.connect = true
            }
        }
        
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let b = defaults1.objectForKey("loginStatus") as? Bool {
            loginStatus = defaults1.objectForKey("loginStatus") as Bool
        }
        if loginStatus == false {
            self.tabBarController!.performSegueWithIdentifier("toLogIn", sender: self)
        }
        
        tabBarController!.customizableViewControllers = [NSArray]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.activityy()
            dispatch_async(dispatch_get_main_queue(), {
                self.taskDone()
            })
        })
    }
    
    func tabBarController(tabBarController: UITabBarController!, shouldSelectViewController viewController: UIViewController!) -> Bool {
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let b = defaults1.objectForKey("doneLoading") as? Bool {
            doneLoading = defaults1.objectForKey("doneLoading") as Bool
        }
        if doneLoading != true {
            return false
        }
        return true
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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sideMenu = SideMenu(sourceView: self.view, menuData: ["LogOut", "Profile Pic"])
        sideMenu!.delegate = self

        self.welcomeLabel.textColor = UIColor.whiteColor()
        
        if UIScreen.mainScreen().bounds.size.height >= 568 {
        }else{
            self.welcomeLabel.frame = CGRectMake(self.welcomeLabel.bounds.origin.x, self.welcomeLabel.bounds.origin.y - 10, self.welcomeLabel.bounds.size.width, self.welcomeLabel.bounds.size.height)
            self.welcomeLabel.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 220)
            self.welcomeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 21)
            
            self.blurViewImageView.frame = CGRectMake(self.blurViewImageView.bounds.origin.x, self.blurViewImageView.bounds.origin.y, self.blurViewImageView.bounds.size.width, 75)
            self.profileImageView.frame = CGRectMake(131, 60, 70, 70)
            self.profileImageView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 165)
            
            self.yourProgress.frame = CGRectMake(35, 125, 265, 21)
            self.allWordsPercentCount.frame = CGRectMake(35,165,101,65)
            self.highFrequencyPercentCount.frame = CGRectMake(185,165,101,65)
            self.allWrdsReadCount.frame = CGRectMake(0, 228, 170, 21)
            self.hfReadCount.frame = CGRectMake(150, 228, 170, 21)
            self.allWordsPlainLabel.frame = CGRectMake(0, 250, 170, 21)
            self.hfPlainLabel.frame = CGRectMake(150, 250, 170, 21)
            self.stayHungry.frame = CGRectMake(20, 300, 280, 70)
        }
        
        
        self.tabBarController!.delegate = self
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let data = defaults1.objectForKey("userData") as? [String]{
            self.userData = defaults1.objectForKey("userData") as [String]
        }
        
        if let abc = defaults1.objectForKey("profilePic") as? NSData{
            self.imageData = defaults1.objectForKey("profilePic") as NSData
            var pImage = UIImage(data: imageData)
            self.profileImageView.imageView!.image = pImage
        }
        
        if self.isConnectionAvailble() == false {
            self.connect = false
            //var imgData:NSData = defaults1.objectForKey("savedImage") as NSData
            //var profileImagee:UIImage = UIImage(data: imgData) as UIImage
            self.welcomeLabel.text = "Welcome !"
            //self.profileImageView.imageView!.image = profileImagee
            //self.blurViewImageView.image = profileImagee
            self.view.addSubview(self.blurViewImageView)
            self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2
            self.profileImageView.layer.masksToBounds = true
            self.profileImageView.layer.borderColor = UIColor.blackColor().CGColor
            self.profileImageView.layer.borderWidth = 1.2
            self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
            self.blurEffectView.frame = self.blurViewImageView.frame
            var vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.blurEffect)
            var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyEffectView.frame = self.blurViewImageView.frame
            vibrancyEffectView.addSubview(self.welcomeLabel)
            self.blurEffectView.contentView.addSubview(vibrancyEffectView)
            self.blurEffectView.addSubview(self.profileImageView)
            self.view.addSubview(self.blurEffectView)
        }else {
            if (PFUser.currentUser() != nil && isConnectionAvailble() == true){
                var findUser:PFQuery = PFUser.query()
                findUser.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
                findUser.findObjectsInBackgroundWithBlock({
                    (user: [AnyObject]!, error: NSError!)->Void in
                    if user.count > 0 {
                        var onlyUser:PFUser = user[0] as PFUser
                        var firstN:String = onlyUser.objectForKey("firstName") as String
                        firstN = firstN.capitalizedString
                        self.welcomeLabel.text = "Welcome, \(firstN) !"
                        var proImage:PFFile = onlyUser["profilePic"] as PFFile
                        proImage.getDataInBackgroundWithBlock({
                            (imageDatass: NSData!, error: NSError!)->Void in
                            if !(error != nil) {
                                var profileImagee:UIImage = UIImage(data: imageDatass)
                                self.profileImageView.imageView!.image = profileImagee
                                self.blurViewImageView.image = profileImagee
                                self.view.addSubview(self.blurViewImageView)
                                self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width/2
                                self.profileImageView.layer.masksToBounds = true
                                self.profileImageView.layer.borderColor = UIColor.blackColor().CGColor
                                self.profileImageView.layer.borderWidth = 1.2
                                
                                self.blurEffectView = UIVisualEffectView(effect: self.blurEffect)
                                self.blurEffectView.frame = self.blurViewImageView.frame
                                
                                
                                var vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.blurEffect)
                                var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                                vibrancyEffectView.frame = self.blurViewImageView.frame
                                
                                vibrancyEffectView.addSubview(self.welcomeLabel)
                                self.blurEffectView.contentView.addSubview(vibrancyEffectView)
                                self.blurEffectView.addSubview(self.profileImageView)
                                self.view.addSubview(self.blurEffectView)
                            }
                        })
                    }
                })
            }
        }
        
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        self.navigationItem.title = "Progress"
        
        if let c = defaults1.objectForKey("allWordsReadCount") as? Int {
            self.allWordsReadCount = defaults1.objectForKey("allWordsReadCount") as Int
        }
        if let d = defaults1.objectForKey("highFrequencyWordsReadCount") as? Int {
            self.highFrequencyWordsReadCount = defaults1.objectForKey("highFrequencyWordsReadCount") as Int
        }
        var allpercent: Double = ceil((Double(allWordsReadCount)/Double(3751)) * 100)
        var np = Int(allpercent)
        allWordsPercentCount.text = "\(np)%"
        var allpercent2: Double = ceil((Double(highFrequencyWordsReadCount)/Double(811)) * 100)
        np = Int(allpercent2)
        highFrequencyPercentCount.text = "\(np)%"
        allWrdsReadCount.text = "\(allWordsReadCount) of 3751 words"
        hfReadCount.text = "\(highFrequencyWordsReadCount) of 811 words"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        if let b = defaults1.objectForKey("loginStatus") as? Bool {
            loginStatus = defaults1.objectForKey("loginStatus") as Bool
        }
        
        if loginStatus == true {
        }
        
        if first1 == false{
            self.menuView3 = MGFashionMenuView(menuView: createExampleView3(), animationType: MGAnimationType.Wave )
            self.view.addSubview(menuView3)
            first1 = true
        }
        
    }
    
    func createExampleView3()->UIView{
        var view:UIView = UIView(frame: CGRectMake(0, 0, 320, 200))
        view.backgroundColor = UIColor(red: 163/255, green: 33/255, blue: 18/255, alpha: 1)
        return view
    }
    
    
    func taskDone(){
        self.indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        blurView.hidden = true
        self.viewDidLoad()
    }
    
    func activityy() {
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let b = defaults1.objectForKey("first") as? Bool {
            first = defaults1.objectForKey("first") as Bool
        }
        if first == false {
            first = true
            defaults1.setValue(first, forKey: "first")
            defaults1.synchronize()
            self.indicator.startAnimating()
            blurView.hidden = false
            LoadData()
        }
        
    }
    
    override func didReceiveMemoryWarning()  {
        super.didReceiveMemoryWarning()
    }
    
    func LoadData()->Bool{
        var bool = false
        var tempstring = ""
        var array = [String]()
        var temparray = [String]()
        var temparray1 = [String]()
        var allwordsarray = [String]()
        let path = NSBundle.mainBundle().pathForResource("allWords", ofType: "txt")
        var possibleContent = String.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil)
        var goInside = false
        var meaning = [String]()
        if let content = possibleContent {
            array = content.componentsSeparatedByString("\n")
        }
        
        for index in 0..<array.count{
            temparray.append(array[index])
        }
        var countss = 0
        for temp in temparray{
            temparray1 = temp.componentsSeparatedByString("$")
            for index in 0..<temparray1.count {
                temparray1[index] = temparray1[index].stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            if temparray1[0] == "abash" {
                goInside = true
            }
            if goInside {
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                var context: NSManagedObjectContext = appDel.managedObjectContext
                if (temparray1[1] != wordMeaning) {
                    wordMeaning = temparray1[1]
                    var newWord = NSEntityDescription.insertNewObjectForEntityForName("Words", inManagedObjectContext: context) as NSManagedObject
                    newWord.setValue(temparray1[0], forKey: "wordName")
                    if temparray1[0] == "zephyr"{
                        goInside = false
                    }
                    newWord.setValue(temparray1[1], forKey: "meaning")
                    
                    temparray1[2] = temparray1[2].stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    newWord.setValue(temparray1[2], forKey: "synonym")
                    
                    temparray1[3] = temparray1[3].stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    newWord.setValue(temparray1[3], forKey: "sentance")
                    
                    newWord.setValue(temparray1[4].toInt(), forKey: "seen")
                    newWord.setValue(temparray1[5].toInt(), forKey: "highFreq")
                    newWord.setValue(temparray1[6].toInt(), forKey: "set")
                    context.save(nil)
                }else{
                    continue
                }
            }
        }
        println("done")
        doneLoading = true
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(doneLoading, forKey: "doneLoading")
        defaults1.synchronize()
        var alert = UIAlertController(title: "Data Loading Complete", message: "Please dont forget to rate the App !", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        self.viewDidLoad()
        return true
    }
    
    func actualLogout(){
        PFUser.logOut()
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(false, forKey: "loginStatus")
        defaults1.synchronize()
        self.tabBarController!.performSegueWithIdentifier("toLogIn", sender: self)
    }
    
    @IBAction func logOut(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }
    
    
    func toggleMenu(t: NSTimer){
        sideMenu?.toggleMenu()
    }
    
    func sideMenuDidSelectItemAtIndex(index: Int) {
        if index == 0 {
            self.actualLogout()
            var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "toggleMenu:", userInfo: nil, repeats: false)
        }else{
            var timer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "toggleMenu:", userInfo: nil, repeats: false)
            var imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!){
        var pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        var imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setObject(imageData, forKey: "savedImage")
        defaults1.synchronize()
        var imageFile:PFFile = PFFile(data: imageData)
        picker.dismissViewControllerAnimated(true, completion: nil)
        var curUser = PFUser.currentUser()
        curUser.setObject(imageFile, forKey: "profilePic")
        curUser.saveInBackgroundWithBlock({
            (done: Bool, error: NSError!) in
            if error == nil {
                self.viewDidLoad()
            }
        })
    }
}