//
//  selectSetForQuiz.swift
//  FlashCard
//
//  Created by Rikin Desai on 7/4/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

var ss:selectSetForQuiz = selectSetForQuiz()

class selectSetForQuiz: UIViewController, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource {
    var selectedCellIndices = [Int]()
    
    @IBOutlet var tableView: UITableView! = UITableView()
    @IBOutlet var buttonHFWordQuiz: UIButton! = UIButton()
    @IBOutlet var doneBtn: UIButton! = UIButton()
    @IBAction func done(sender: UIButton){
    }
    var setFirstWordArray = [String]()
    var setSecondWordArray = [String]()
    var loaded = false
    
    override func viewWillAppear(animated: Bool) {
        self.selectedCellIndices = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        selectedCellIndices = []
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        self.title = "Select Set(s)"
        buttonHFWordQuiz.layer.borderWidth = 0.5
        buttonHFWordQuiz.layer.cornerRadius = 5
    
        if let abc = tableView.tableHeaderView {
            tableView.tableHeaderView = UIView(frame: CGRectZero)
        }

        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var defaults2: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let ab = defaults1.objectForKey("loadingManager") as? Bool {
            self.loaded = defaults1.objectForKey("loadingManager") as Bool
        }
        
        if self.loaded == false {
            dm.makeWordSetArray()
        }

        if let aksjd = defaults1.objectForKey("setFirstWordArray") as? [String] {
            self.setFirstWordArray = defaults1.objectForKey("setFirstWordArray") as [String]
        }
        if let bcgs = defaults2.objectForKey("setSecondWordArray") as? [String] {
            self.setSecondWordArray = defaults1.objectForKey("setSecondWordArray") as [String]
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func HFQuiz(sender: UIButton) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return setFirstWordArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "setWords")
        if (selectedCellIndices.filter { $0 == indexPath.row }.count > 0){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell.textLabel!.text = "Set \(indexPath.row + 1)"
        if indexPath.row < 76 {
            var first:NSString = self.setFirstWordArray[indexPath.row] as NSString
            var second:NSString = self.setFirstWordArray[indexPath.row + 1] as NSString
            first = first.capitalizedString
            second = second.capitalizedString
            cell.detailTextLabel!.text = "\(first) to \(second)"
        }else{
            cell.detailTextLabel!.text = "Yoke to Zephyr"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell!.accessoryType == UITableViewCellAccessoryType.None {
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            if (selectedCellIndices.filter { $0 == indexPath.row }.count < 1){
                selectedCellIndices.append(indexPath.row)
            }
        }else {
            selectedCell!.accessoryType = UITableViewCellAccessoryType.None
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.None
            selectedCellIndices = selectedCellIndices.filter( {$0 != indexPath.row})
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func unwindToSelectSet(backToStart: UIStoryboardSegue){
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "doneSelectSet") {
            var QT: QuizTaker = segue.destinationViewController as QuizTaker
            QT.selectedCellIndicesFromSelectSet = self.selectedCellIndices
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}