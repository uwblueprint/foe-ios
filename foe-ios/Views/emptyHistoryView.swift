//
//  emptyHistoryView.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-06-19.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class emptyHistoryView: UIView {
    
    var contentView: UIView?
    var descriptionString:NSString = "You can begin by tapping Capture below."
    
    @IBOutlet var yOffsetConstraint: NSLayoutConstraint!
    //:- Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var illustrationImage: UIImage?
    @IBInspectable var title: String?
    
    func setVerticalOffset(y: CGFloat) {
        yOffsetConstraint.constant = y
        layoutIfNeeded()
    }
    
    func removeIllustration() {
        illustrationImageView.image = nil
        yOffsetConstraint.constant -= illustrationImageView.bounds.height/2
    }
    
    private func initialize () {
        guard let view = loadViewFromNib() else { return }
        addSubview(view)
        
        if (illustrationImage != nil) {
            illustrationImageView.image = illustrationImage
        }
        
        if (title != nil) {
            titleLabel.text = title
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = "emptyHistoryView"
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
