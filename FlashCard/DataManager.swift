//
//  DataManager.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/15/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//
import Foundation
import UIKit
import CoreData

var dm = DataManager()

class DataManager: NSObject{
    var setFirstWordArray = [String]()
    var setSecondWordArray = [String]()

    override init() {
    }

    func makeWordSetArray(){
        var oldset = 1
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)!
        var tempData = result[0] as NSManagedObject
        var tempWordName = tempData.valueForKey("wordName") as String
        self.setFirstWordArray.append(tempWordName)
        for index in 0..<result.count{
            var tempRes = result[index] as NSManagedObject
            var setNumber = tempRes.valueForKey("set") as Int
            if oldset != setNumber{
                oldset = setNumber
                var tempIndexMinusOneWord = result[index-1].valueForKey("wordName") as String
                var indexWord = tempRes.valueForKey("wordName") as String
                self.setSecondWordArray.append(tempIndexMinusOneWord)
                self.setFirstWordArray.append(indexWord)
            }else{
                continue
            }
        }
        self.setSecondWordArray.append("zephyr")
        var defaults1: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults1.setValue(setFirstWordArray, forKey: "setFirstWordArray")
        defaults1.synchronize()
        var defaults2: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults2.setValue(setSecondWordArray, forKey: "setSecondWordArray")
        defaults2.synchronize()
        defaults1.setValue(true, forKey: "loadingManager")
        defaults1.synchronize()
    }
}