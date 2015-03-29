//
//  TimeLineTable.swift
//  FlashCard
//
//  Created by Rikin Desai on 8/22/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class TimeLineTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var timelineData:[AnyObject] = [AnyObject]()
    var first = false
    @IBOutlet var tableViw: UITableView! = UITableView()

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    func loadData(sender: AnyObject){
        if isConnectionAvailble() == true {
            timelineData.removeAll(keepCapacity: false)
            var findTimelineData:PFQuery = PFQuery(className: "Sweets")
            findTimelineData.findObjectsInBackgroundWithBlock({
                (objects:[AnyObject]!, error:NSError!)->Void in
                if error == nil{
                    var tempData:NSMutableArray = NSMutableArray()
                    for object in objects{
                        var tempObj = object as PFObject
                        tempData.addObject(tempObj)
                    }
                    if tempData.count > 0 {
                        self.timelineData = tempData
                    }
                    self.timelineData = self.timelineData.reverse()
                    self.tableViw.reloadData()
                }else {
                    println("errors")
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConnectionAvailble() == false {
            var alert = UIAlertController(title: "Internet Connection Not Available", message: "Cannot Load Data", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            return self.timelineData.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:SweetTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewCell", forIndexPath: indexPath) as SweetTableViewCell
        if isConnectionAvailble() == true {
            let sweet:PFObject = self.timelineData[indexPath.row] as PFObject
            cell.sweetTextView.text = sweet.objectForKey("content") as String
            cell.sweetTextView.layer.cornerRadius = 5
            var dataFormatter:NSDateFormatter = NSDateFormatter()
            dataFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            var onlydataFormatter:NSDateFormatter = NSDateFormatter()
            onlydataFormatter.dateFormat = "MM/dd/yy"
            var timeOfSweet:String = dataFormatter.stringFromDate(sweet.createdAt)
            var dateSplit:[String] = timeOfSweet.componentsSeparatedByString(" ")
            var datePart:[String] = dateSplit[0].componentsSeparatedByString("-")
            var timePart:[String] = dateSplit[1].componentsSeparatedByString(":")
            
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            let month = components.month
            let year = components.year
            let day = components.day
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
                            image = self.scaleImageWith(image, and: CGSizeMake(60, 60))
                            //dispatch_async(dispatch_get_main_queue(), {
                            cell.profImg.image = image
                            cell.profImg.layer.cornerRadius = image.size.width/2
                            cell.profImg.layer.masksToBounds  = true
                            cell.profImg.layer.borderColor = UIColor.blackColor().CGColor
                            cell.profImg.layer.borderWidth = 0.7
                            //})
                        }
                    }
                }
            }            
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 123 as CGFloat
    }
    
    func scaleImageWith(image:UIImage, and newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    @IBAction func reloadData(sender: AnyObject) {
        self.loadData(50)
    }
    
}