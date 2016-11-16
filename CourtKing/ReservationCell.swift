//
//  ReservationCell.swift
//  CourtKing
//
//  Created by MU IT Program on 11/7/16.
//  Copyright © 2016 MU IT Program. All rights reserved.
//

import UIKit

class ReservationCell: UITableViewCell {
    
    static let reuseIdentifier = "ReservationCell"


    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var teamCaptain: UILabel!
    
    @IBOutlet weak var teammate1: UILabel!
    
    @IBOutlet weak var teammate2: UILabel!
    
    @IBOutlet weak var teammate3: UILabel!
    
    @IBOutlet weak var teammate4: UILabel!    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
