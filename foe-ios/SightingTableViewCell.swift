//
//  SightingTableViewCell.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SightingTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sightingCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: sightingCellView.bounds)
        sightingCellView.layer.masksToBounds = false
        sightingCellView.layer.shadowColor = UIColor.black.cgColor
        sightingCellView.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        sightingCellView.layer.shadowOpacity = 0.05
        sightingCellView.layer.shadowPath = shadowPath.cgPath
        sightingCellView.layer.shadowRadius = 14.0
    }

}
