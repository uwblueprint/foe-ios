//
//  NosePicker.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-01-25.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

@IBDesignable class NosePicker: UIScrollView {
    
    //MARK: Properties
    private var buttons = [UIButton]()
    private var items = [NosePickerItem]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0)
    
    let h = 64
    let w = 64
    let padding = 16
    let n = 10
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 100, width: 500, height: h + (2 * padding)))
        self.contentSize =  CGSize (width: ((w + padding) * n), height: h)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.yellow
        
        setupButtons()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentSize =  CGSize (width: ((w + padding) * n), height: h)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.yellow
        setupButtons()
    }
    
    convenience init(frame: CGRect, items: [NosePickerItem]) {
        self.init(frame: frame)
        self.items = items
        print("items count: \(self.items.count)")
    }
    
    //MARK: Button Action
    
    func ratingButtonTapped(button: UIButton) {
        print("⛄️")
    }
    //MARK: Private Methods
    
    private func setupButtons() {
        for i in 0..<items.count {
            let button = UIButton()
//            button.setImage(items[i].getImage(), for: .normal)
            button.frame = CGRect(x: padding * (i + 1) + (i * w), y: padding, width: w, height: h)
//            button.layer.cornerRadius = CGFloat(w/2)
//            button.clipsToBounds = true
            button.backgroundColor = UIColor.red
            
            button.addTarget(self, action: #selector(NosePicker.ratingButtonTapped(button:)), for: .touchUpInside)
            
            self.addSubview(button)
            
            buttons.append(button)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
