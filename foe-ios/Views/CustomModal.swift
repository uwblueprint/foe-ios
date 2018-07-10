//
//  CustomModal.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-02-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class CustomModal: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    var onDismiss : (() -> Void)? = nil
    
    convenience init(title:String, caption: String, dismissText: String, image: UIImage?, onDismiss: (() -> Void)? = nil) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, caption: caption, dismissText: dismissText, image: image, onDismiss: onDismiss)
        
    }
    
    convenience init(species: String, onDismiss: (() -> Void)? = nil) {
        self.init(frame: UIScreen.main.bounds)
        initialize(species: species, onDismiss: onDismiss)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(species: String, onDismiss: (() -> Void)? = nil) {
            self.onDismiss = onDismiss
            dialogView.clipsToBounds = true
            
            backgroundView.frame = frame
            backgroundView.backgroundColor = UIColor.black
            backgroundView.alpha = 0.6
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
            addSubview(backgroundView)
            
            let dialogViewWidth = frame.width - 24 * 2
        
            let speciesBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: dialogViewWidth, height: 240))
        
            speciesBackgroundView.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.81, alpha:1.0)
        
            let imageView = UIImageView(frame: CGRect(x: (dialogViewWidth-135)/2 , y: 40.5, width: 135, height: 135))
        
            imageView.image = UIImage(named: species)!
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            dialogView.addSubview(speciesBackgroundView)
            dialogView.addSubview(imageView)
            
            
            let titleLabel = UILabel()
            titleLabel.frame.origin = CGPoint(x: 24, y: speciesBackgroundView.frame.height + 24)
            titleLabel.frame.size = CGSize(width: dialogViewWidth - 24 * 2, height: 55)
            titleLabel.text = SpeciesMap.getCommonName(species)
            titleLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.5
            titleLabel.numberOfLines = 0
            titleLabel.contentMode = .scaleToFill
            dialogView.addSubview(titleLabel)
            
            let captionLabel = UILabel()
            captionLabel.frame.origin = CGPoint(x: 24, y: titleLabel.frame.height + titleLabel.frame.origin.y + 4)
            captionLabel.frame.size = CGSize(width: dialogViewWidth - 24*2, height: 100)
            captionLabel.numberOfLines = 0
            captionLabel.text = "Like most bumble bees, it is yellow and black, but males and workers have a distinctive rusty-coloured patch on the second segment of the abdomen."
            captionLabel.contentMode = .scaleToFill
            captionLabel.font = UIFont(name: "Avenir", size: 16)
            dialogView.addSubview(captionLabel)
        
            let binomialLabel = UILabel()
            binomialLabel.frame.origin = CGPoint(x: 24, y: speciesBackgroundView.frame.height - 38)
            binomialLabel.frame.size = CGSize(width: dialogViewWidth - 24*2, height: 22)
            binomialLabel.text = SpeciesMap.getDisplayBinomialName(species)
            binomialLabel.contentMode = .scaleToFill
            binomialLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
            binomialLabel.textColor = UIColor(red:0.89, green:0.67, blue:0.09, alpha:1.0)
            dialogView.addSubview(binomialLabel)
            
            //creating CTA with icon
            let primaryCTA = UIView()
            
            let CTAActionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 54, height: 20))
            CTAActionLabel.text = "Close"
            CTAActionLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
            CTAActionLabel.textColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
            
            primaryCTA.addSubview(CTAActionLabel)
            
            let CTAIconImage = UIImageView()
            CTAIconImage.frame.origin = CGPoint(x: CTAActionLabel.frame.width, y: 1)
            CTAIconImage.frame.size = CGSize(width: 17, height: 17)
            CTAIconImage.image = UIImage(named:"close-icon-green")!
            
            primaryCTA.addSubview(CTAIconImage)
            
            primaryCTA.frame.size = CGSize(width: CTAActionLabel.frame.width + CTAIconImage.frame.width + 4, height: 20)
            primaryCTA.frame.origin = CGPoint(x: dialogViewWidth - primaryCTA.frame.width - 24, y: captionLabel.frame.height + captionLabel.frame.origin.y + 24)
            primaryCTA.backgroundColor = UIColor.white
            primaryCTA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
            dialogView.addSubview(primaryCTA)
            
            let dialogViewHeight = speciesBackgroundView.frame.height + titleLabel.frame.height + captionLabel.frame.height  + primaryCTA.frame.height + 24 * 3 + 4
            
            dialogView.frame.origin = CGPoint(x: 24, y: frame.height)
            dialogView.frame.size = CGSize(width: frame.width-24*2, height: dialogViewHeight)
            dialogView.backgroundColor = UIColor.white
            addSubview(dialogView)
    }
    
    func initialize(title: String, caption: String, dismissText: String, image: UIImage?, onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width - 24 * 2
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dialogViewWidth, height: 240))
        if (image == nil) {
            imageView.frame = CGRect(x:0, y:0, width: dialogViewWidth, height: 0)
        }
        else {
            imageView.image = image
            imageView.backgroundColor = UIColor(red:1.00, green:0.99, blue:0.81, alpha:1.0)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dialogView.addSubview(imageView)
        
        
        let titleLabel = UILabel()
        titleLabel.frame.origin = CGPoint(x: 24, y: imageView.frame.height + 24)
        titleLabel.frame.size = CGSize(width: dialogViewWidth - 24 * 2, height: 44)
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 32)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 0
        titleLabel.contentMode = .scaleToFill
        dialogView.addSubview(titleLabel)
        
        let captionLabel = UILabel()
        captionLabel.frame.origin = CGPoint(x: 24, y: titleLabel.frame.height + titleLabel.frame.origin.y + 4)
        captionLabel.frame.size = CGSize(width: dialogViewWidth - 32, height: 22 * 2)
        captionLabel.numberOfLines = 0
        captionLabel.text = caption
        captionLabel.contentMode = .scaleToFill
        captionLabel.font = UIFont(name: "Avenir Medium", size: 16)
        dialogView.addSubview(captionLabel)
        
        //creating CTA with icon
        let primaryCTA = UIView()
        
        let CTAActionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 54, height: 20))
        CTAActionLabel.text = dismissText
        CTAActionLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        CTAActionLabel.textColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        
        primaryCTA.addSubview(CTAActionLabel)
        
        let CTAIconImage = UIImageView()
        CTAIconImage.frame.origin = (dismissText == "Close") ? CGPoint(x: CTAActionLabel.frame.width, y: 1) : CGPoint(x: CTAActionLabel.frame.width + 4, y: 1)
        CTAIconImage.frame.size = (dismissText == "Close") ? CGSize(width: 17, height: 17) : CGSize(width: 23, height: 17)
        CTAIconImage.image = (dismissText == "Close") ? UIImage(named:"close-icon-green")! : UIImage(named:"green-checkmark")!
        
        primaryCTA.addSubview(CTAIconImage)

        primaryCTA.frame.size = CGSize(width: CTAActionLabel.frame.width + CTAIconImage.frame.width + 4, height: 20)
        primaryCTA.frame.origin = CGPoint(x: dialogViewWidth - primaryCTA.frame.width - 24, y: captionLabel.frame.height + captionLabel.frame.origin.y + 24)
        primaryCTA.backgroundColor = UIColor.white
        primaryCTA.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        dialogView.addSubview(primaryCTA)
        
        let dialogViewHeight = imageView.frame.height + titleLabel.frame.height + captionLabel.frame.height  + primaryCTA.frame.height + 24 * 3 + 4
        
        dialogView.frame.origin = CGPoint(x: 24, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-24*2, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        addSubview(dialogView)
    }
    
    func didTappedOnBackgroundView(){
        dismiss(animated: true)
        if (self.onDismiss != nil) {
            self.onDismiss!()
        }
    }
}
