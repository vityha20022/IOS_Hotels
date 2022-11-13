//
//  HostelsTableViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 13.11.2022.
//

import UIKit

class HotelsTableViewController: UITableViewController {
    var hotelDescriptions: [HotelDescription]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
    }
    
    
    func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Hotels"
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false;
    }
    
    func getNumberAvailableRoomsFor(hotel: HotelDescription) -> Int {
        let suitesAvailability = hotel.suitesAvailability
        return suitesAvailability.split(separator: ":").count
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotelDescriptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hotel = hotelDescriptions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell", for: indexPath) as! HotelTableViewCell
        
        cell.hotelNameLabel.text = hotel.name
        cell.hotelStarsLabel.text = String(hotel.stars)
        cell.hotelAddressLabel.text = hotel.address
        cell.hotelDistanceToCityCenterLabel.text = "\(hotel.distance) meters to city center"
        cell.hotelAvailableRoomsLabel.text = "\(getNumberAvailableRoomsFor(hotel: hotel)) available rooms now"
        
        
        return cell
            
    }

}
