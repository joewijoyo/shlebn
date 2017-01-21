//
//  FilteredTableViewCell.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/20/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class FilteredTableViewCell: UITableViewCell {

    @IBOutlet weak var cellText: UITextView!
    @IBOutlet weak var cellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
