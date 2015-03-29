//
//  quizResults.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/25/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit

class quizResult: UIViewController, UITextFieldDelegate {

    var score = 0
    var totalQuest = 0
    var newcolor2 = UIColor(red: 251/255, green: 39/255, blue: 65/255, alpha: 1)

    @IBOutlet var scroll: UIScrollView! = nil
    @IBOutlet var hereAreYourResults: UILabel! = nil
    @IBOutlet var content: UIView! = nil
    @IBOutlet var resultPercent: UILabel! = nil
    @IBOutlet var resultOutOf: UILabel!
    @IBOutlet var Quote: UILabel! = nil
    
    @IBOutlet var doneQuiz: UIButton! = UIButton()
    
    var quote = ["Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time.","Always do your best. What you plant now, you will harvest later","By failing to prepare, you are preparing to fail","With the new day comes new strength and new thoughts","Don't watch the clock; do what it does. Keep going","You have to learn the rules of the game. And then you have to play better than anyone else","Start where you are. Use what you have. Do what you can","Do you want to know who you are? Don't ask. Act! Action will delineate and define you","Without hard work, nothing grows but weeds","I don't believe you have to be better than everybody else. I believe you have to be better than you ever thought you could be","If you don't design your own life plan, chances are you'll fall into someone else's plan. And guess what they have planned for you? Not much","Learn from the past, set vivid, detailed goals for the future, and live in the only moment of time over which you have any control: now","Your talent is God's gift to you. What you do with it is your gift back to God","A creative man is motivated by the desire to achieve, not by the desire to beat others"]
    
    var author = ["Thomas A. Edison","Og Mandino","Benjamin Franklin","Eleanor Roosevelt","Sam Levenson","Albert Einstein","Arthur Ashe","Thomas Jefferson","Gordon B. Hinckley","Ken Venturi","Jim Rohn","Denis Waitley","Leo Buscaglia","Ayn Rand"]

    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        scroll.layoutIfNeeded()
        scroll.contentSize = content.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        if let sc = scroll{
            self.scroll.layoutIfNeeded()
            self.scroll.contentSize = self.content.bounds.size
        }
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        self.navigationItem.hidesBackButton = true
        hereAreYourResults.text = "Here are your results"
        var np = 0
        if score > 0 {
            var percent: Double = ceil((Double(score)/Double(totalQuest)) * 100)
            np = Int(percent)
            if np < 0 {
                np = 0
            }
        }else{
            np = 0
        }
        resultPercent.text = "\(np)%"
        resultOutOf.text = "\(score) of \(totalQuest) answers"
        var rand = randomNumber(quote.count)
        Quote.text = "\"\(quote[rand])\"\n -\(author[rand])"

        var rect:CGRect
        Quote.lineBreakMode = NSLineBreakMode.ByWordWrapping
        var quoText:NSString = Quote.text! as NSString
        rect = quoText.boundingRectWithSize(CGSizeMake(320, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: Quote.font], context: nil)
        Quote.frame = CGRectMake(37, 175, 272, rect.height)

        var newViewFrame = CGRect(x: 0, y: 0, width: 320, height: Quote.frame.origin.y + Quote.frame.size.height + 25)
        content.frame = newViewFrame

        self.navigationItem.title = "Results"
        resultPercent.textColor = newcolor2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func randomNumber(range: Int)->Int{
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    @IBAction func doneQuiz(sender: UIButton) {
        self.tabBarController!.selectedIndex = 2
    }
    @IBAction func unwindToStartQuiz(sender: UIButton) {
        self.performSegueWithIdentifier("unwindToQuizMakerSegueID", sender: self)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}