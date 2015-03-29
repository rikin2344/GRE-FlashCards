//
//  ViewController.swift
//  FlashCard
//
//  Created by Rikin Desai on 7/9/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var counts = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nsuerstuff(sender: AnyObject) {
        counts = counts + 10
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(counts, forKey: "counts")
        defaults.synchronize()
        
    }
    @IBAction func printing(sender: AnyObject) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let ab = defaults.objectForKey("counts") as? Int{
            counts = defaults.objectForKey("counts") as Int
        }
        
    }
    func loadData() {
        var bool = false
        var tempstring = ""
        var array = [String]()
        var temparray = [String]()
        var temparray1 = [String]()
        var allwordsarray = [String]()
        let path = NSBundle.mainBundle().pathForResource("allWords", ofType: "txt")
        var possibleContent = String.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil)
        var goInside = false
        var meaning = [String]()
        if let content = possibleContent {
            array = content.componentsSeparatedByString("\n")
        }
        
        for index in 0..<array.count{
            temparray.append(array[index])
        }
        
        for temp in temparray{
            temparray1 = temp.componentsSeparatedByString("$")
            for index in 0..<temparray1.count {
                temparray1[index] = temparray1[index].stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                temparray1[index] = temparray1[index].stringByReplacingOccurrencesOfString(".:", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            if temparray1[0] == "abash" {
                goInside = true
            }
            if goInside {
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                var context: NSManagedObjectContext = appDel.managedObjectContext
                var newWord = NSEntityDescription.insertNewObjectForEntityForName("Words", inManagedObjectContext: context) as NSManagedObject

                //var wordsss: NSString = temparray1[0] as NSString
                newWord.setValue(temparray1[0], forKey: "wordName")
                if temparray1[0] == "zephyr"{
                    goInside = false
                }
                
                //if temparray1[1].bridgeToObjectiveC().containsString(", "){
                //meaning = temparray1[1].componentsSeparatedByString(", ")
                //}else{
                //meaning = temparray1[1].componentsSeparatedByString("; ")
                //}
                
                newWord.setValue(temparray1[1], forKey: "meaning")
                
                //var finalmean = [NSString]()
                //for mean in meaning {
                //  finalmean.append(mean as NSString)
                //}
                
                newWord.setValue(temparray1[2], forKey: "synonym")
                
                //var synss = temparray1[2].componentsSeparatedByString(", ")
                //for index in 0..<synss.count{
                //  synss[index] = synss[index].stringByReplacingOccurrencesOfString(":", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                //}
                
                //var sent = temparray1[3]
                
                newWord.setValue(temparray1[3], forKey: "sentance")
                
                //var seenss = temparray1[4].toInt()
                
                newWord.setValue(temparray1[4].toInt(), forKey: "seen")
                newWord.setValue(temparray1[5].toInt(), forKey: "highFreq")
                newWord.setValue(temparray1[6].toInt(), forKey: "set")
                
                
                var hfss = temparray1[5].toInt()
                var setss = temparray1[6].toInt()
                //self.addWord(wordsss, meaning: finalmean, sentance: sent, syn: synss, seen: seenss!, set: setss!, HF: hfss!)
                context.save(nil)
            }
        }

        
/*
        
        
        //Following code returns the word name
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Words")
        request.returnsObjectsAsFaults = false
        var result: NSArray = context.executeFetchRequest(request, error: nil)
        /*
        var count = 0
            //var modres = result[count] as NSManagedObject
        var tempmod = result[0] as NSManagedObject
        tempmod.setValue(1, forKey: "seen")
        var tempmod1 = result[1] as NSManagedObject
        tempmod1.setValue(1, forKey: "seen")
        */
        
        //To change the value !
        
        //result[0].setValue(0, forKey: "seen")
        //result[1].setValue(0, forKey: "seen")
        //context.save(nil)
        
        var context1: NSManagedObjectContext = appDel.managedObjectContext

        var request1 = NSFetchRequest(entityName: "Words")
        request1.returnsObjectsAsFaults = false
        //request1.predicate = NSPredicate(format: "wordName = %@", "abate")
        var newresult:NSArray = context1.executeFetchRequest(request1, error: nil)
        for res in newresult{
            var modres = res as NSManagedObject
            print(modres.valueForKey("wordName") as String)
            println(modres.valueForKey("seen") as Int)
            
        }

        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext
        var newCount = NSEntityDescription.insertNewObjectForEntityForName("Count", inManagedObjectContext: context) as NSManagedObject
        newCount.setValue(0, forKey: "count")
        context.save(nil)
        println("count created and saved forever !!")
*/
    }

}

