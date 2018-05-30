//
//  MainUITabController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-04-25.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

class MainUITabBarController: UITabBarController {
    
    fileprivate lazy var defaultTabBarHeight = { self.tabBar.frame.size.height }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 8.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
    }
    
}
