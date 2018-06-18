//
//  SightingTableViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

class SightingTableViewController: UITableViewController {
    
    var sightings = [Sighting]()
    var statusBarShouldBeHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    //MARK: Outlets
    @IBOutlet weak var headerView: UIView!
    var activeCell = false
    
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
        
        sightings += [exampleSighting, sighting_2, exampleSighting, sighting_2, exampleSighting]
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SightingDetailViewController") as! SightingDetailViewController
        
        controller.sightingModel = sightings[indexPath.row]
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        self.present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.delaysContentTouches = false

        fetchSightings()

        print("work")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SightingTableViewCell else {
            fatalError("dequeued cell is not an instance of SightingTableViewCell")
        }
        
        let sighting = sightings[indexPath.row]
        
        cell.locationLabel.text = sighting.getLocationName()
        cell.photoImageView.image = sighting.getImage()
        cell.speciesLabel.text = SpeciesMap.getCommonName(sighting.getSpecies())
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

    private func fetchSightings() {
        ServerGateway.authenticatedRequest(
            url: "/sightings",
            method: .get,
            parameters: nil,
            success: { (_ response: DataResponse<Any>) in
                let rawSightings = response.result.value as! Array<Any>
                print("raw: \(rawSightings)")
                
                self.sightings = rawSightings.map { json in
                    let dict = json as! NSDictionary
                    return Sighting(json: dict as! [String: Any])
                }
                self.tableView.reloadData()
            },
            failure: { _ in }
        )
    }
    
    
}
