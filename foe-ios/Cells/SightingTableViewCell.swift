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
    @IBOutlet weak var paddedCellWidth: NSLayoutConstraint!
    
    var disabledAnimation = false
    let kHighlightedFactor: CGFloat = 0.96
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradientView = UIView(frame: photoImageView.frame)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y:0.6)
        let blackColor = UIColor.black
        gradient.colors = [blackColor.withAlphaComponent(0.5).cgColor, blackColor.withAlphaComponent(0.2), blackColor.withAlphaComponent(0.0).cgColor]
        //        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
        photoImageView.addSubview(gradientView)
        photoImageView.bringSubview(toFront: gradientView)
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
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledAnimation { return }
        if isHighlighted {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIViewAnimationOptions.beginFromCurrentState], animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: self.kHighlightedFactor, y: self.kHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [UIViewAnimationOptions.beginFromCurrentState], animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animate(isHighlighted: false)
    }

}
