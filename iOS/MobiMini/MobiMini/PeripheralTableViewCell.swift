//
//  PeripheralTableViewCell.swift
//  MobiMini
//
//  Created by Edward on 7/15/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit

class PeripheralTableViewCell: UITableViewCell {

    @IBOutlet weak var peripheralID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
