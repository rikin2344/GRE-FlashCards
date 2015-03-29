//
//  Trial.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/20/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreData

var trial = Trial()

class Trial: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var inittransform = CATransform3D(m11: 0, m12: 0, m13: 0, m14: 0, m21: 0, m22: 0, m23: 0, m24: 0, m31: 0, m32: 0, m33: 0, m34: 0, m41: 0, m42: 0, m43: 0, m44: 0)
    var countOfTrial = 0
    var results = NSArray()
    
    @IBOutlet var tblView: UITableView! = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        tblView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        tabBarController!.customizableViewControllers = [NSArray]()
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        
        //Requesting the data from CoreData Model
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        results = result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3751
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        //Using the data obtained to fill the table
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "display")
        var data = results[indexPath.row] as NSManagedObject
        cell.textLabel!.text = (data.valueForKey("wordName") as String).capitalizedString
        var tempMeaning = data.valueForKey("meaning") as String
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("*", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("@", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        cell.detailTextLabel!.text = tempMeaning
        
        //Adding checkmark to the seen words
        var isSeen = data.valueForKey("seen") as Int
        if isSeen == 1 {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        fromTCount = indexPath.row
        countOfTrial = indexPath.row
        self.tabBarController!.selectedIndex = 2
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}