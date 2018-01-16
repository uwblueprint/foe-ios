//
//  FactTableViewCell.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-15.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class FactTableViewCell: UITableViewCell {

    @IBOutlet weak var factImage: UIImageView!
    @IBOutlet weak var factTitle: UILabel!
    @IBOutlet weak var factCopy: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
