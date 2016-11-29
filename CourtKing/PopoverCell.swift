//
//  PopoverCell.swift
//  CourtKing
//
//  Created by MU IT Program on 11/28/16.
//  Copyright © 2016 MU IT Program. All rights reserved.
//

import UIKit

class PopoverCell: UITableViewCell {

    static let reuseIdentifier = "PopoverCell"
    
    @IBOutlet weak var teamCaptain: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
