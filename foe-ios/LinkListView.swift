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
    var links : [String:String]
    
    override init(frame: CGRect) {
        links = [String:String]()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openLinkURL(_ sender: Any) {
        let button = sender as! UIButton
        let key = button.titleLabel!.text as String!
        let url = links[key!]
        UIApplication.shared.open(NSURL(string:url!)! as URL)
    }
    
    convenience init(title:String, links: [String:String]) {
        self.init(frame: UIScreen.main.bounds)
        self.links = links
        initialize(title: title, links: links)
    }
    
    func initialize(title: String, links: [String:String]) {
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
        
        let linkKeys = Array(links.keys)
        
        for i in 0..<linkKeys.count {
            print("currentTop: \(currentTop)")
            let primaryCTA = UIView()
            
            let CTAActionLabel = UIButton()
            CTAActionLabel.frame.origin = CGPoint(x: padding, y: 16)
            CTAActionLabel.frame.size = CGSize(width: 300, height: 22)
            CTAActionLabel.setTitle(linkKeys[i], for: .normal)
            CTAActionLabel.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 16)
            CTAActionLabel.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
            CTAActionLabel.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:0.5), for: .highlighted)
            CTAActionLabel.contentHorizontalAlignment = .left
            CTAActionLabel.addTarget(self, action: #selector(openLinkURL(_:)), for: .touchUpInside)
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
            
            //add URL
            addSubview(primaryCTA)
            
            currentTop += primaryCTA.frame.height
        }
        
        frame.size = CGSize(width: LinkListViewWidth, height: currentTop)
        backgroundColor = UIColor.white
    }
}
