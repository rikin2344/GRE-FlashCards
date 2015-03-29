//
//  fromDifficultWords.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/22/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIkit
import QuartzCore
import CoreData

class fromDifficultWords: UIViewController, UITextFieldDelegate{
    @IBOutlet var scroll: UIScrollView! = nil
    @IBOutlet var contentView: UIView! = UIView()
    @IBOutlet var setNumber : UILabel! = nil
    @IBOutlet var wordLabel : UILabel! = UILabel()
    @IBOutlet var wordImage : UIImageView! = nil
    @IBOutlet var meaningLabel : UILabel! = nil
    @IBOutlet var sentanceLabel : UILabel! = nil
    @IBOutlet var synLabel : UILabel! = nil
    
    var currentIndex = 0
    var difficultWords = [Int]()
    override func viewWillAppear(animated: Bool) {
        scroll.layoutIfNeeded()
        scroll.contentSize = contentView.bounds.size
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let e = defaults1.objectForKey("currentindex") as? Int {
            self.currentIndex = defaults1.objectForKey("currentindex") as Int
        }
        setStuff(currentIndex)
        changeViewSize()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.layoutIfNeeded()
        scroll.contentSize = contentView.bounds.size
        setStuff(currentIndex)
        changeViewSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        scroll.layoutIfNeeded()
        scroll.contentSize = contentView.bounds.size
    }
   
    func changeViewSize(){
        var txtsize:CGSize
        var rect:CGRect
        var meanText:NSString = meaningLabel.text! as NSString
        var sentText:NSString = sentanceLabel.text! as NSString
        var synText:NSString = synLabel.text! as NSString
        rect = meanText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: meaningLabel.font], context: nil)
        meaningLabel.frame = CGRectMake(15, 274, 290, rect.height)
        
        sentanceLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        rect = sentText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: sentanceLabel.font], context: nil)
        sentanceLabel.frame = CGRectMake(15, meaningLabel.frame.origin.y + meaningLabel.frame.size.height + 20, 290, rect.height + 23)
        
        rect = synText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: synLabel.font], context: nil)
        synLabel.frame = CGRectMake(15, sentanceLabel.frame.origin.y + sentanceLabel.frame.size.height + 20, 290, rect.height)
        
        var newViewFrame = CGRect(x: 0, y: 0, width: 320, height: synLabel.frame.origin.y + synLabel.frame.size.height + 25)
        contentView.frame = newViewFrame
    }

    func setStuff(newcount: Int){
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let e = defaults1.objectForKey("difficultWords") as? [Int] {
            self.difficultWords = defaults1.objectForKey("difficultWords") as [Int]
        }
        var tempResult = result[difficultWords[newcount]] as NSManagedObject
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
            self.wordImage.image = UIImage(named: wordLabel.text!.lowercaseString)
        }

    }
    
    @IBAction func swipeRight(sender: UIGestureRecognizer){
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var maincount = defaults1.valueForKey("difficultWordsCount") as Int
        self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
            if currentIndex+1 > maincount - 1 {
                return
            }
            currentIndex++
            self.animatestuff(currentIndex)
            changeViewSize()
            self.viewDidLoad()
    }
    
    @IBAction func swipeLeft(sender: UIGestureRecognizer){
        self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
            if currentIndex-1 < 0 {
                return
            }
            currentIndex--
            self.animatestuff(currentIndex)
            changeViewSize()
            self.viewDidLoad()
    }
    
    func animatestuff(currentIndex: Int){
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
        if let wl = wordImage {
            self.wordImage.alpha = 0
        }
        self.setStuff(currentIndex)
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
            if let wl = self.wordImage {
                self.wordImage.alpha = 1
            }
            })
    }
}