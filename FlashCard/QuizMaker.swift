//
//  QuizMaker.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/24/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

var QM = QuizMaker()

@objc(QuizMaker)class QuizMaker: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scroll: UIScrollView! = UIScrollView()
    @IBOutlet var contentView: UIView! = UIView()
    @IBOutlet var currentView: UIView! = UIView()
    @IBOutlet var infoLabel: UILabel! = UILabel()
    @IBOutlet var startNewQuiz : UIButton! = UIButton()
    @IBOutlet var tempView: UIView! = UIView()
    var newcolor2 = UIColor(red: 251/255, green: 39/255, blue: 65/255, alpha: 1)
    override func viewDidAppear(animated: Bool) {
        viewDidLoad()
    }

    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        scroll.layoutIfNeeded()
        scroll.contentSize = contentView.bounds.size
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        startNewQuiz.layer.borderWidth = 0.5
        startNewQuiz.layer.cornerRadius = 5
        startNewQuiz.titleLabel!.textColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        self.navigationItem.title = "Quiz"

        if UIScreen.mainScreen().bounds.size.height >= 568 {
        }else{
        
            self.startNewQuiz.frame = CGRectMake(-5, 322, self.startNewQuiz.bounds.size.width, self.startNewQuiz.bounds.size.height)
        }
        if let sc = scroll{
            self.scroll.layoutIfNeeded()
            self.scroll.contentSize = self.contentView.bounds.size
            self.scroll.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func newQuizMaker(sender: UIButton){
        //self.performSegueWithIdentifier("select", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "select") {
            var ss:selectSetForQuiz = segue.destinationViewController as selectSetForQuiz
        }
    }
    
    @IBAction func unwindToQuizMaker(s:UIStoryboardSegue) {
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}