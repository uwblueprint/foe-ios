//
//  SightingTableViewController.swift
//  foe-ios
//
//  Created by John Salaveria on 2018-05-28.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import UIKit

class SightingTableViewController: UITableViewController {
    @IBOutlet weak var headerView: UIView!
    var navigationBarOriginalOffset : CGFloat?
    
    var sightings = [Sighting]()
    
    let exampleSighting = Sighting()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarOriginalOffset = headerView.frame.origin.y
    }
    
    func loadStaticData () {
        exampleSighting.setImage(image: UIImage(named:"default-home-illustration")!)
        exampleSighting.setSpecies(species: "Common Eastern Bumblebee")
        
        for _ in 0..<5 {
            sightings += [exampleSighting]
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        
        headerView.frame.origin.y = 40
        
//        if(scrollView.contentOffset.y <= -30.0) {
//            headerView.frame.origin.y = navigationBarOriginalOffset! + 14 + (-30 +  scrollView.contentOffset.y * -1)
//        }
        print("header y: \(headerView.frame.origin.y)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
