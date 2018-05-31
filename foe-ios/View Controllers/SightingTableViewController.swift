//
//  SightingTableViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SightingTableViewController: UITableViewController {
    
    var statusBarShouldBeHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    //MARK: Outlets
    @IBOutlet weak var headerView: UIView!
    var activeCell = false
    var navigationBarOriginalOffset : CGFloat?
    
    var sightings = [Sighting]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarOriginalOffset = headerView.frame.origin.y
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func loadStaticData () {
        let exampleSighting = Sighting()
        exampleSighting.setImage(image: UIImage(named:"default-home-illustration")!)
        exampleSighting.setSpecies(species: "Common eastern bumblebee")
        
        let sighting_2 = Sighting()
        sighting_2.setImage(image: UIImage(named:"bee-sample-image")!)
        sighting_2.setSpecies(species: "Black and gold bumblebee")
        
        
        sightings += [exampleSighting, sighting_2, exampleSighting, sighting_2, exampleSighting]
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
        
        loadStaticData()

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
        
        cell.dateLabel.text = "June 1"
        cell.locationLabel.text = "Mississauga, ON"
        cell.photoImageView.image = sighting.getImage()
        cell.speciesLabel.text = sighting.getSpecies()
        cell.statusLabel.text = "Pending"
       
        
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
