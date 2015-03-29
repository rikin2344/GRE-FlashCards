//
//  AppDelegate.swift
//  FlashCard
//
//  Created by Rikin Desai on 7/9/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        Parse.setApplicationId("nCSRQp3qlFb3b6ycg70mZPvvtJr7PvTJft5azK3q", clientKey: "uCw89KjVgH6A80qLhu4RHBqFdWQNETe8CKOLAom0")
        var newcolor = UIColor(red: 163/255, green: 33/255, blue: 18/255, alpha: 1)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        var image:UIImage = UIImage(named: "background2")
        //UINavigationBar.appearance().setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        //UINavigationBar.appearance().backgroundColor = newcolor
        UINavigationBar.appearance().barTintColor = newcolor
        //UINavigationBar.appearance().translucent = false
        //UINavigationBar.appearance().alpha = 0.2
        UITabBar.appearance().tintColor = newcolor
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().titleTextAttributes = aE.navigationBarColorDictionary
        
        // NOTIFICATION SETTING ::
        let notificationTypes:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        return true
    }
    
    func application(application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["Reload"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        println(error.localizedDescription)
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo:NSDictionary!) {
        var notification:NSDictionary = userInfo.objectForKey("aps") as NSDictionary
        if notification.objectForKey("content-available") != nil{
            if notification.objectForKey("content-available")!.isEqualToNumber(1){
                println("push received")
                NSNotificationCenter.defaultCenter().postNotificationName("reloadTimeline", object: nil)
            }
        }else{
            PFPush.handlePush(userInfo)
        }
    }

    

    func applicationWillResignActive(application: UIApplication!) {
    }

    func applicationDidEnterBackground(application: UIApplication!) {
    }

    func applicationWillEnterForeground(application: UIApplication!) {
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTimeline", object: nil)
    }

    func applicationWillTerminate(application: UIApplication!) {
        self.saveContext()
    }

    func application(application: UIApplication!, shouldSaveApplicationState coder: NSCoder!) -> Bool {
        return true
    }
    
    func application(application: UIApplication!, shouldRestoreApplicationState coder: NSCoder!) -> Bool {
        return true        
    }

    
    func saveContext () {
        var error: NSError? = nil
        let managedObjectContext = self.managedObjectContext
        if _managedObjectContext == nil {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
                abort()
            }
        }
    }

    // #pragma mark - Core Data stack
    var managedObjectContext: NSManagedObjectContext {
        if _managedObjectContext == nil{
            let coordinator = self.persistentStoreCoordinator
            if _persistentStoreCoordinator != nil {
                _managedObjectContext = NSManagedObjectContext()
                _managedObjectContext!.persistentStoreCoordinator = coordinator
            }
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil
    var managedObjectModel: NSManagedObjectModel {
        if _managedObjectModel == nil {
            let modelURL = NSBundle.mainBundle().URLForResource("FlashCard", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil

    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if _persistentStoreCoordinator == nil {
            let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("FlashCard.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                abort()
            }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil

    // #pragma mark - Application's Documents directory
                                    
    var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }

}

