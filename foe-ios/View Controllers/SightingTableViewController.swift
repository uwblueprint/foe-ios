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
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    //MARK: Outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sightingCountLabel: UILabel!
    var activeCell = false
    var isLoaded = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        tableView.reloadData()
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
        self.tableView.isScrollEnabled = true
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = pullToRefreshControl
        } else {
            self.tableView.addSubview(pullToRefreshControl)
        }

        //load placeholder cells for to improve perceived responsiveness
        sightings += [Sighting(), Sighting()]

        fetchSightings()
    }
    
    lazy var pullToRefreshControl: UIRefreshControl = {
        let pullToRefreshControl = UIRefreshControl()
        pullToRefreshControl.addTarget(self, action:
            #selector(SightingTableViewController.handleRefresh),
                                       for: UIControlEvents.valueChanged)
        return pullToRefreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.isUserInteractionEnabled = false
        defer {
            self.tableView.isUserInteractionEnabled = true
            self.refreshControl?.endRefreshing()
        }

        fetchSightings()
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
        cell.speciesLabel.text = SpeciesMap.getCommonName(sighting.getSpecies())

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

                self.sightings = rawSightings.enumerated().map { (index, json) in
                    let dict = json as! NSDictionary
                    let indexPath = IndexPath(item: index, section: 0)
                    return Sighting(
                        json: dict as! [String: Any],
                        imageRenderedCallback: { self.tableView.reloadRows(at: [indexPath], with: .none) }
                    )
                }
                
                if (self.sightings.count == 0) {
                    self.renderEmptyState()
                } else {
                    self.tableView.backgroundView = nil
                    self.isLoaded = true
                    self.sightingCountLabel.text = "\(self.sightings.count) sightings"
                    self.tableView.reloadData()
                }
            },
            failure: { _ in
                let alert = CustomModal(
                    title: "Uh oh",
                    caption: "There was a server error in processing your request.",
                    dismissText: "Done",
                    image: nil,
                    onDismiss: nil
                )
                alert.show(animated: true)
        }
        )
    }
}
