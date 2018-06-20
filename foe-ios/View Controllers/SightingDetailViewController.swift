//
//  SightingDetailViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-30.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit


class SightingDetailViewController: UIViewController {
    
    var sightingModel = Sighting()
    
    //MARK: Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var speciesImageBGView: UIView!
    @IBOutlet weak var speciesNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var habitatLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var binomialNameLabel: UILabel!
    @IBOutlet weak var speciesImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func handleSightingCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func renderInformation() {
        speciesNameLabel.text = SpeciesMap.getCommonName(sightingModel.getSpecies())
        binomialNameLabel.text = SpeciesMap.getDisplayBinomialName(sightingModel.getSpecies())
        habitatLabel.text = self.sightingModel.getHabitat()
        weatherImageView.image = UIImage(named: self.sightingModel.getWeather())!
        weatherDescriptionLabel.text = snakecaseToCapitalized(self.sightingModel.getWeather())
        locationLabel.text = self.sightingModel.getLocationName()
        
        let dateFormatter = DateFormatter()
        
        // set to US English locale and format as "<Month Name> <Number>"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        dateLabel.text = dateFormatter.string(from: self.sightingModel.getDate())
        
        //set species image
        speciesImageView.image = UIImage(named: self.sightingModel.getSpecies())!
        
    }
    
    override func viewDidLoad() {
        print("view created")
        super.viewDidLoad()
        
        renderInformation()
        

        // Do any additional setup after loading the view.
        
        photoImageView.image = sightingModel.getImage()
        speciesImageBGView.layer.cornerRadius = speciesImageBGView.frame.width/2
        
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
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blur.frame = closeButton.bounds
        blur.layer.cornerRadius = 16
        blur.clipsToBounds = true
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        closeButton.insertSubview(blur, at: 0)
        closeButton.bringSubview(toFront: closeButton.imageView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
