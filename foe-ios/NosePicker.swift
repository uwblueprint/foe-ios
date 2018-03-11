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
    var n = 10
    var callback : ((String)->())? = nil
    var activeButtonIdentifier : String = ""
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    convenience init(frame: CGRect, items: [NosePickerItem], updateCallback : @escaping (_ res: String)->()) {
        self.init(frame: frame)
        self.items = items
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        setupButtons()
        updateSelectedView()
        self.callback = updateCallback
    }
    
    //MARK: Button Action
    
    func loadNewButtons (newItems: [NosePickerItem]) {
        //remove previous buttons from view
        for i in 0..<self.items.count {
            buttons[i].removeFromSuperview()
        }
    
        buttons.removeAll()
        
        self.items = newItems
        setupButtons()
        updateSelectedView()
    }
    
    func speciesButtonTapped(button: UIButton) {
        print("\(self.items[button.tag].getIdentifier()) pressed")
        self.activeButtonIdentifier = items[button.tag].getIdentifier()
        updateSelectedView()
        
        self.callback!(activeButtonIdentifier)
    }
    
    //MARK: Private Methods
  
    private func updateSelectedView() {
        for i in 0..<buttons.count {
            if (items[buttons[i].tag].getIdentifier() == activeButtonIdentifier) {
                buttons[i].layer.borderWidth = 4
                buttons[i].layer.borderColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0).cgColor
            } else {
                buttons[i].layer.borderWidth = 0
            }
        }
    }
  
    private func setupButtons() {
        self.n = items.count
        self.contentSize =  CGSize (width: ((w + padding) * n) + padding, height: h)
        for i in 0..<items.count {
            let button = UIButton()
            button.setImage(items[i].getImage(), for: .normal)
            button.frame = CGRect(x: padding * (i + 1) + (i * w), y: padding, width: w, height: h)
            button.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
            button.layer.cornerRadius = CGFloat(w/2)
            button.clipsToBounds = true
            self.backgroundColor = UIColor.white
            
            button.tag = i
            button.addTarget(self, action: #selector(NosePicker.speciesButtonTapped(button:)), for: .touchUpInside)
            
            self.addSubview(button)
            
            buttons.append(button)
        }
    }
}
