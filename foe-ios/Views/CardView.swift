//
//  CardView.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-03-01.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    let title : String = ""
    let subtitle : String = ""
    let caption : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String, caption:String, subtitle:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, caption: caption, subtitle: subtitle)
        
    }
    
    func initialize(title:String, caption:String, subtitle:String) {
        let CardViewWidth = frame.width
        let padding : CGFloat = 24
        
        let subtitleLabel = UILabel()
        subtitleLabel.frame.origin = CGPoint(x: padding, y: padding * 2)
        subtitleLabel.frame.size = CGSize(width: CardViewWidth - padding*2, height: 22)
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        subtitleLabel.textColor = UIColor.white
        
        addSubview(subtitleLabel)
        
        let titleLabel = UILabel()
        titleLabel.frame.origin = CGPoint(x: 24, y: subtitleLabel.frame.height + subtitleLabel.frame.origin.y + padding/3)
        titleLabel.frame.size = CGSize(width: CardViewWidth - padding*2, height: 30 * 2)
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        titleLabel.contentMode = .scaleToFill
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        addSubview(titleLabel)
        
        let defaultImage = UIImageView()
        defaultImage.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + titleLabel.frame.origin.y + padding)
        defaultImage.frame.size = CGSize(width: CardViewWidth, height: 300)
        defaultImage.image = UIImage(named: "default-home-illustration")!
        titleLabel.contentMode = .scaleAspectFill
        
        addSubview(defaultImage)
        
        backgroundColor = UIColor(red:0.40, green:0.85, blue:1.00, alpha:1.0)
        
        frame.size = CGSize(width: CardViewWidth, height: 200 + defaultImage.frame.height)
    }
}
