
/*

//
//  TimelineTableViewController.swift
//  SwifferApp
//
//  Created by Training on 29/06/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class TimelineTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var timelineData:NSMutableArray = NSMutableArray()
    var first = false
    @IBOutlet var tableView: UITableView! = UITableView()
    
    override func viewDidAppear(animated: Bool) {
    }

    func scaleImageWith(image:UIImage, and newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    override func viewWillAppear(animated: Bool) {
        if self.first == false {
            self.loadData(56)
            self.first = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData(56)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData:", name: "reloadTimeline", object: nil)
        self.navigationItem.title = "Newsfeed"
    }
    
    @IBAction func loadData(sender: AnyObject){
        timelineData.removeAllObjects()
        var findTimelineData:PFQuery = PFQuery(className: "Sweets")
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            if error == nil{
                for object in objects{
                    var tempObj = object as PFObject
                    self.timelineData.addObject(tempObj)
                }
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = array as NSMutableArray
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TimelineTableViewController{ // TableView Datasource and Delegate
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timelineData.count
    }
    
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell:SweetTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath!) as SweetTableViewCell
        
        let sweet:PFObject = self.timelineData.objectAtIndex(indexPath!.row) as PFObject
        
        //cell.sweetTextView.alpha = 0
        //cell.timestampLabel.alpha = 0
        //cell.usernameLabel.alpha = 0
        cell.sweetTextView.text = sweet.objectForKey("content") as String
        cell.sweetTextView.layer.cornerRadius = 5
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var onlydataFormatter:NSDateFormatter = NSDateFormatter()
        onlydataFormatter.dateFormat = "MM/dd/yy"
       // cell.timestampLabel.text = dataFormatter.stringFromDate(sweet.createdAt)
        var timeOfSweet:String = dataFormatter.stringFromDate(sweet.createdAt)
        var dateSplit:[String] = timeOfSweet.componentsSeparatedByString(" ")
        var datePart:[String] = dateSplit[0].componentsSeparatedByString("-")
        var timePart:[String] = dateSplit[1].componentsSeparatedByString(":")

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        //let components1 = calendar.components()
        let hour = components.hour
        let minutes = components.minute
        let month = components.month
        let year = components.year
        let day = components.day
        /*
        if year == datePart[2].toInt()! {
            if month == datePart[0].toInt()! {
                if day == datePart[1].toInt()! {
                    if timePart[0].toInt()! > 12 {
                        timePart[0] = String(timePart[0].toInt()! - 12)
                        timePart[1] += " PM"
                    }else {
                        timePart[1] += " AM"                        
                    }
                    cell.timestampLabel.text = "\(timePart[0]):\(timePart[1])"
                }else if ( (day - 1) == datePart[1].toInt()!) {
                    cell.timestampLabel.text = "Yesterday"
                }else{
                    cell.timestampLabel.text = onlydataFormatter.stringFromDate(sweet.createdAt)
                }
            }else{
                cell.timestampLabel.text = onlydataFormatter.stringFromDate(sweet.createdAt)
            }
        }else{
            cell.timestampLabel.text = onlydataFormatter.stringFromDate(sweet.createdAt)
        }
*/


        
        var findSweeter:PFQuery = PFUser.query()
        findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("sweeter").objectId)
        
        findSweeter.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            if error == nil{
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.usernameLabel.text = user.username.capitalizedString
                let profileImage:PFFile = user["profilePic"] as PFFile

                profileImage.getDataInBackgroundWithBlock{
                    (imageData:NSData!, error:NSError!)->Void in
                    
                    if error == nil{
                        var image:UIImage = UIImage(data: imageData)
                        //image = self.scaleImageWith(image, and: CGSizeMake(60, 60))
                        cell.profileImageView.image = image
                        cell.profileImageView.layer.cornerRadius = image.size.width/2
                        cell.profileImageView.layer.masksToBounds  = true
                        cell.profileImageView.layer.borderColor = UIColor.blackColor().CGColor
                        cell.profileImageView.layer.borderWidth = 0.7
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

*/
