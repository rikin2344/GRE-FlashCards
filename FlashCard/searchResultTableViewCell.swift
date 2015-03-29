//
//  searchResultTableViewCell.swift
//  FlashCard
//
//  Created by Rikin Desai on 6/17/14.
//  Copyright (c) 2014 Rikin. All rights reserved.
//

import Foundation
import UIKit

class searchResultTableViewCell: UITableViewCell {

    @IBOutlet var namelabel : UILabel! = nil
    @IBOutlet var meaninglabel : UILabel! = nil
    @IBOutlet var numberlabel : UILabel! = nil

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
}