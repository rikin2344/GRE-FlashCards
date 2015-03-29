//
//  difficultWordsTable.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/22/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

var df = difficultWordsTable()

import Foundation
import UIKit
import QuartzCore
import CoreData

class difficultWordsTable: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    var currentindex = 0
    var countb4update = 0
    var results = NSArray()
    var difficultWords = [Int]()
  
    @IBOutlet var tblView: UITableView! = UITableView()
   
    override func viewWillAppear(animated: Bool) {
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let a = defaults1.valueForKey("difficultWords") as? [Int]{
            difficultWords = defaults1.valueForKey("difficultWords") as [Int]
        }
        if countb4update != difficultWords.count{
            tblView.reloadData()            
        }
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes = aE.navigationBarColorDictionary
        
        //Querying the CoreDataModel
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        results = result
        
        //Loading the difficultWords Table
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let e = defaults1.objectForKey("difficultWords") as? [Int] {
            self.difficultWords = defaults1.objectForKey("difficultWords") as [Int]
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countb4update = difficultWords.count
        return difficultWords.count
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "dfwords")
    
        //Loading the data from the results obtained
        var data = results[difficultWords[indexPath.row]] as NSManagedObject
        cell.textLabel!.text = (data.valueForKey("wordName") as String).capitalizedString
        
        var tempMeaning = data.valueForKey("meaning") as String
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("*", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tempMeaning = tempMeaning.stringByReplacingOccurrencesOfString("@", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

        cell.detailTextLabel!.text = tempMeaning
        return cell
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            difficultWords.removeAtIndex(indexPath.row)
            tblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(self.difficultWords, forKey: "difficultWords")
        defaults1.synchronize()
        self.viewDidLoad()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing{
            super.setEditing(true, animated: true)
            self.tblView.setEditing(true, animated: true)
            tblView.reloadData()
        }else{
            super.setEditing(false, animated: true)
            self.tblView.setEditing(false, animated: true)
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        currentindex = indexPath.row
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(currentindex, forKey: "currentindex")
        defaults1.synchronize()
        self.performSegueWithIdentifier("fromDifficultWords", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "fromDifficultWords") {
            var fromDW: fromDifficultWords = segue.destinationViewController as fromDifficultWords
            var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults1.setValue(self.difficultWords.count, forKey: "difficultWordsCount")
            defaults1.synchronize()
        }
    }    
}