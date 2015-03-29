//
//  TimeLine.swift
//  FlashCard
//
//  Created by Rikin Desai on 8/21/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit

class TimeLine: UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate{
   
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
    
    func scaleImageWith(image:UIImage, and newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
}