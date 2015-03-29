//
//  FlashCards.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/15/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

var Fc = FlashCards()
var fromTCount = -10
var wordSelected = ""

class FlashCards: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var scroll : UIScrollView! = nil
    @IBOutlet var setNumber : UILabel! = nil
    @IBOutlet var contentView : UIView! = UIView()
    @IBOutlet var wordLabel :UILabel! = UILabel()
    @IBOutlet var wordImage : UIImageView! = nil
    @IBOutlet var meaningLabel :UILabel! = UILabel()
    @IBOutlet var sentanceLabel :UILabel! = UILabel()
    @IBOutlet var synLabel :UILabel! = UILabel()
    @IBOutlet var progressView : UIProgressView! = nil
    @IBOutlet var segmentedControl: UISegmentedControl! = nil

    var count = 0
    var track = [Int]()
    var count1: Int = 0
    var HFcount = 861
    var currentcount = 0
    var allWordsReadCount = 0
    var highFrequencyWordsReadCount = 0
    var firsttime = false
    var flag = false
    var HFWordCount = 0
    var difficultWords = [Int]()

    //Make all words readcount and highfreqreadcount to 0
    //because it will always change when ever u run the app.
    
    func saveVariables(){
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(self.count, forKey: "countFromFC")
        defaults1.setValue(self.flag, forKey: "flag")
        defaults1.setValue(self.firsttime, forKey: "firsttime")
        defaults1.setValue(self.allWordsReadCount, forKey: "allWordsReadCount")
        defaults1.setValue(self.highFrequencyWordsReadCount, forKey: "highFrequencyWordsReadCount")
        defaults1.setValue(self.difficultWords, forKey: "difficultWords")
        defaults1.setValue(self.count1, forKey: "count1")
        defaults1.synchronize()
    }
    
    //Reloading data from local copy
    
    func reloadFromBackUp(){
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let a = defaults1.objectForKey("countFromFC") as? Int {
            count = defaults1.objectForKey("countFromFC") as Int
        }
        if let a = defaults1.objectForKey("count1") as? Int {
            count1 = defaults1.objectForKey("count1") as Int
        }

        if let b = defaults1.objectForKey("flag") as? Bool {
            flag = defaults1.objectForKey("flag") as Bool
        }
        if let c = defaults1.objectForKey("allWordsReadCount") as? Int {
            allWordsReadCount = defaults1.objectForKey("allWordsReadCount") as Int
        }
        if let d = defaults1.objectForKey("highFrequencyWordsReadCount") as? Int {
            highFrequencyWordsReadCount = defaults1.objectForKey("highFrequencyWordsReadCount") as Int
        }
        if let e = defaults1.objectForKey("difficultWords") as? [Int] {
            difficultWords = defaults1.objectForKey("difficultWords") as [Int]
        }
        if let f = defaults1.objectForKey("firsttime") as? Bool {
            firsttime = defaults1.objectForKey("firsttime") as Bool
        }
    }
   
    // Called before the viewAppears
    
    override func viewWillAppear(animated: Bool) {
        reloadFromBackUp()
        if wordSelected != "" {
            var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            var context: NSManagedObjectContext = appDel.managedObjectContext
            var anotherRequest = NSFetchRequest(entityName: "Words")
            anotherRequest.returnsObjectsAsFaults = false
            var anotherResult: NSArray = context.executeFetchRequest(anotherRequest, error: nil)!
            
            for index in 0..<anotherResult.count {
                var data = anotherResult[index] as NSManagedObject
                if data.valueForKey("wordName") as String == wordSelected {
                    count = index
                    saveVariables()
                    break
                }
            }
            wordSelected = ""
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
        else if fromTCount >= 0{
            count = fromTCount
            fromTCount = -10
            saveVariables()
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
        else if segmentedControl.selectedSegmentIndex == 0 {
            setStuff(count)
            changeViewSize()
            viewDidLoad()
            saveVariables()
        }else {
            setStuff(count1)
            changeViewSize()
            viewDidLoad()
            saveVariables()
        }
    }
    
    // Change size of labels according to text
    func changeViewSize(){
        var txtsize:CGSize
        var rect:CGRect
        
        var meanText:NSString = meaningLabel.text! as NSString
        var sentText:NSString = sentanceLabel.text! as NSString
        var synText:NSString = synLabel.text! as NSString

        meaningLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rect = (meaningLabel.text! as NSString).boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: meaningLabel.font], context: nil)
        meaningLabel.frame = CGRectMake(15, 274, 290, rect.height)
        if rect.height < 25 {
            if meanText.length > 29 {
                meaningLabel.frame = CGRectMake(15, 274, 290, rect.height + 23)
            }
        }
        
        sentanceLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rect = sentText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: sentanceLabel.font], context: nil)
        sentanceLabel.frame = CGRectMake(15, meaningLabel.frame.origin.y + meaningLabel.frame.size.height + 20, 290, rect.height + 23)

        synLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rect = synText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: synLabel.font], context: nil)
        synLabel.frame = CGRectMake(15, sentanceLabel.frame.origin.y + sentanceLabel.frame.size.height, 290, rect.height+23)

        
        var newViewFrame = CGRect(x: 0, y: 0, width: 320, height: synLabel.frame.origin.y + synLabel.frame.size.height + 25)
        contentView.frame = newViewFrame
    }
   
    // setting up the Scroll views
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        scroll.layoutIfNeeded()
        scroll.contentSize = contentView.bounds.size
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        reloadFromBackUp()
        if flag == false {
            if count > 0 {
                self.setStuff(count)
            }else {
                self.setStuff(0)
            }
            changeViewSize()
            flag = true
            saveVariables()
        }
        if let sc = scroll{
            self.scroll.layoutIfNeeded()
            self.scroll.contentSize = self.contentView.bounds.size
            self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        segmentedControl.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Setting all labels to new values
    
    func setStuff(newcount: Int){
        currentcount = newcount
        reloadFromBackUp()
        
        // Querying data from parse
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        var tempResult = result[newcount] as NSManagedObject

        if let sn = wordLabel{
            self.wordLabel.text = (tempResult.valueForKey("wordName") as String).capitalizedString
        }
        
        var tempMeaning = tempResult.valueForKey("meaning") as String
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("*", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("@", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if let sn = meaningLabel{
                self.meaningLabel.text = tempMeaning
        }
        var tempsyn = tempResult.valueForKey("synonym") as String
        if let sy = synLabel{
            self.synLabel.text = "Synonym(s): " + tempsyn
        }
        var tempset = tempResult.valueForKey("set") as Int
        if let sn = setNumber{
            self.setNumber.text = "Set Number: \(tempset)"
        }
            if let sn = sentanceLabel{
                self.sentanceLabel.text = tempResult.valueForKey("sentance") as? String
        }
 
        if let sn = wordImage{
            self.wordImage!.image = UIImage(named: wordLabel.text!.lowercaseString)
        }
        
        var isSeen = tempResult.valueForKey("seen") as Int
        var isHF = tempResult.valueForKey("highFreq") as Int
        if isSeen == 0 {
            ++allWordsReadCount
            if isHF == 1 {
                ++highFrequencyWordsReadCount
            }
            result[newcount].setValue(1, forKey: "seen")
            context.save(nil)
        }
        saveVariables()
    }
    
    // Handling right swipe gesture
    
    @IBAction func swipeRight(sender: UIGestureRecognizer){
        reloadFromBackUp()
        self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            if count+1 > 3750 {
                return
            }
            count++
            saveVariables()
            self.animatestuff(count, comingFrom: 1)
            changeViewSize()
            self.viewDidLoad()
        }else{
            if HFWordCount+1 > HFcount {
                return
            }
            HFWordCount++
            count1 = findNextHFWord(count1)
            var backUpCount1 = count1
            saveVariables()
            self.animatestuff(count1, comingFrom: 2)
            changeViewSize()
            self.viewDidLoad()
        }
    }
    
    // Handling left swipe gesture
    
    @IBAction func swipeLeft(sender: UIGestureRecognizer){
        reloadFromBackUp()
        self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        if segmentedControl.selectedSegmentIndex == 0 {
            if count-1 < 0 {
                return
            }
            count--
            saveVariables()
            self.animatestuff(count, comingFrom: 1)
            changeViewSize()
            self.viewDidLoad()
        }else{
            if HFWordCount - 1 <= 0 {
                return
            }
            HFWordCount--
            track.removeLast()
            count1 = track[track.endIndex-1]
            saveVariables()
            self.animatestuff(count1, comingFrom: 2)
            changeViewSize()
            self.viewDidLoad()
        }
    }
    // Handling long press gesture

    @IBAction func longPress(sender: UIGestureRecognizer){
        reloadFromBackUp()
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        var tempResult = result[currentcount] as NSManagedObject
        var tempArray:NSMutableArray = NSMutableArray(array: difficultWords)
        if tempArray.containsObject(currentcount) == false {
            difficultWords.append(currentcount)
            var tempword = (tempResult.valueForKey("wordName") as String).capitalizedString

            GoogleWearAlert.showAlert(title: "Added", type: .Success)
        }
        df.difficultWords = self.difficultWords
        saveVariables()
    }

    // Find the new high frequency word

    func findNextHFWord(countt1: Int)-> Int{
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        
        var newcount = countt1
        newcount++
        for i in newcount..<result.count{
            var res = result[i] as NSManagedObject
            var tempHF = res.valueForKey("highFreq") as Int
            if tempHF != 1{
                continue
            }else{
                track.append(i)
                return i
            }
        }
        return countt1
    }

    // Manages the segmented control
    
    @IBAction func segmentedButton(sender: UISegmentedControl){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!

        reloadFromBackUp()
        if sender.selectedSegmentIndex == 1 {
            self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
            var c = 0
            if firsttime == false {
                var boo = false
                for res in result{
                    var tempres = res as NSManagedObject
                    var tempHF = tempres.valueForKey("highFreq") as Int
                    if tempHF == 1 && boo == false {
                        self.animatestuff(c, comingFrom: 2)
                        track.append(c)
                        count1 = c
                        saveVariables()
                        HFWordCount++
                        self.viewDidLoad()
                        boo = true
                    }
                    if boo == true {
                        break
                    }
                    c++
                }
                firsttime = true
            }else{
                self.animatestuff(count1, comingFrom: 2)
                changeViewSize()
                self.viewDidLoad()
            }
        }else{
            self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
            self.animatestuff(count, comingFrom: 1)
            changeViewSize()
            self.viewDidLoad()
        }
        saveVariables()
    }
    
    // handles basic animation while data is being set
    
    func animatestuff(count: Int, comingFrom: Int){

        if let sn = wordLabel{
            self.wordLabel.alpha = 0
        }
        if let wl = setNumber {
            self.setNumber.alpha = 0
        }
        if let wl = meaningLabel {
            self.meaningLabel.alpha = 0
        }
        if let wl = sentanceLabel {
            self.sentanceLabel.alpha = 0
        }
        if let wl = synLabel {
            self.synLabel.alpha = 0
        }
        if let wl = progressView {
            self.progressView.alpha = 0
        }
        if let wl = wordImage {
            self.wordImage.alpha = 0
        }
        self.setStuff(count)
        UIView.animateWithDuration(1, animations: {
            if let sn = self.wordLabel{
                self.wordLabel.alpha = 1
            }
            if let wl = self.setNumber {
                self.setNumber.alpha = 1
            }
            if let wl = self.meaningLabel {
                self.meaningLabel.alpha = 1
            }
            if let wl = self.sentanceLabel {
                self.sentanceLabel.alpha = 1
            }
            if let wl = self.synLabel {
                self.synLabel.alpha = 1
            }
            if let wl = self.progressView {
                self.progressView.alpha = 1
            }
            if let wl = self.wordImage {
                self.wordImage.alpha = 1
            }
            })
    }
}
