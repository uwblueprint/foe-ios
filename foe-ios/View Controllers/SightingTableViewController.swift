//
//  SightingTableViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import GooglePlaces

class SightingTableViewController: UITableViewController {
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    //MARK: Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sightingCountLabel: UILabel!
    var activeCell = false
    var isLoaded = false
    
    var sightings = [Sighting]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // TODO(dinah): remove all static data
    func loadStaticPlace () {
        let placeIds = ["ChIJBaxtrQH0K4gRkicxTySDDbw", "ChIJP_Ie6gb0K4gRzYmW4JFMrcY"]
        let placesClient = GMSPlacesClient.init()
        
        placesClient.lookUpPlaceID(placeIds[1], callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeIds[1])")
                return
            }
            
            self.loadStaticData(place: place)
            print("Place name \(place.name)")
        })
    }
    
    func loadStaticData (place: GMSPlace) {
        let exampleSighting = Sighting()
        exampleSighting.setImage(image: UIImage(named:"bee-sample-image-1")!)
        exampleSighting.setSpecies(species: "bombus_bimaculatus")
        exampleSighting.setLocation(location: place)
        exampleSighting.setHabitat(habitat: "Fast food restaurant")
        exampleSighting.setWeather(weather: "sunny")
        
        let sighting_2 = Sighting()
        sighting_2.setImage(image: UIImage(named:"bee-sample-image-0")!)
        sighting_2.setSpecies(species: "bombus_melanopygus")
        sighting_2.setLocation(location: place)
        sighting_2.setHabitat(habitat: "Garden")
        sighting_2.setWeather(weather: "partly_cloudy")
        
        sightings = [exampleSighting, sighting_2, exampleSighting, sighting_2, exampleSighting]
        isLoaded = true
        self.tableView.isScrollEnabled = true
        sightingCountLabel.text = "\(sightings.count) sightings"
        
        if (sightings.count == 0) {
            renderEmptyState()
        }
        
        tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!isLoaded) {
             return
        }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SightingDetailViewController") as! SightingDetailViewController
        
        controller.sightingModel = sightings[indexPath.row]
        statusBarHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func renderEmptyState() {
        self.tableView.backgroundView = emptyHistoryView()
        sightingCountLabel.text = "No sightings"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            statusBarHidden = false
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delaysContentTouches = false
        self.tableView.isScrollEnabled = false
        
        //load placeholder cells for to improve perceived responsiveness
        sightings += [Sighting(), Sighting()]


        loadStaticPlace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sightings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SightingTableViewCell"
        let placeholderIdentifier = "SightingTableViewPlaceholderCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SightingTableViewCell else {
            fatalError("dequeued cell is not an instance of SightingTableViewCell")
        }
        
        let placeholder = tableView.dequeueReusableCell(withIdentifier: placeholderIdentifier, for: indexPath)
        
        let sighting = sightings[indexPath.row]
        
        if (!self.isLoaded) {
            return placeholder
        }
        
        cell.locationLabel.text = sighting.getLocationName()
        cell.photoImageView.image = sighting.getImage()
        cell.speciesLabel.text = SpeciesMap.getCommonName(sighting: sighting)
        cell.statusLabel.text = "Pending"
        
        let dateFormatter = DateFormatter()
        
        // set to US English locale and format as "<Month Name> <Number>"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        cell.dateLabel.text = dateFormatter.string(from: sighting.getDate())
       
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
