//
//  LinkListView.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-03-01.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class LinkListView: UIView {
    let title : String = ""
    let links = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String, links: [String]) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, links: links)
    }
    
    func initialize(title: String, links: [String]) {
        
        let LinkListViewWidth = frame.width
        let padding : CGFloat = 24
        
        let subtitleLabel = UILabel()
        subtitleLabel.frame.origin = CGPoint(x: padding, y: padding)
        subtitleLabel.frame.size = CGSize(width: LinkListViewWidth - padding*2, height: 22)
        subtitleLabel.text = title
        subtitleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        subtitleLabel.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
        
        addSubview(subtitleLabel)
        
        var currentTop = subtitleLabel.frame.height + subtitleLabel.frame.origin.y + 4

        
        for i in 0..<links.count {
            
            print("currentTop: \(currentTop)")
            let primaryCTA = UIView()
            
            let CTAActionLabel = UILabel()
            CTAActionLabel.frame.origin = CGPoint(x: padding, y: 16)
            CTAActionLabel.frame.size = CGSize(width: 300, height: 22)
            CTAActionLabel.text = links[i]
            CTAActionLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
            CTAActionLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
            
            primaryCTA.addSubview(CTAActionLabel)
            
            let CTAIconImage = UIImageView()
            CTAIconImage.frame.size = CGSize(width: 12, height: 20)
            CTAIconImage.frame.origin = CGPoint(x: LinkListViewWidth - CTAIconImage.frame.width - padding, y: 16)
            CTAIconImage.image = UIImage(named:"chevron-right")!
            
            primaryCTA.addSubview(CTAIconImage)
            
            if (i != links.count - 1) {
                let separator = UIView()
                separator.frame.size = CGSize(width: LinkListViewWidth - padding * 2, height: 2)
                separator.frame.origin = CGPoint(x: padding, y: CTAActionLabel.frame.origin.y + CTAActionLabel.frame.height + 16)
                separator.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
                primaryCTA.addSubview(separator)
                
            }
            
            primaryCTA.frame.size = CGSize(width: LinkListViewWidth, height: CTAActionLabel.frame.height + 32 + 2)
            primaryCTA.frame.origin = CGPoint(x: 0, y: currentTop)
            
            addSubview(primaryCTA)
            
            currentTop += primaryCTA.frame.height
        }
        
        frame.size = CGSize(width: LinkListViewWidth, height: currentTop)
    }
}
