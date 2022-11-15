//
//  HotelPageViewController.swift
//  HostelApp
//
//  Created by Виктор Борисовский on 15.11.2022.
//

import UIKit

class HotelPageViewController: UIViewController {
    @IBOutlet weak var hotelImageOutlet: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var hotelDistanceToCenterLabel: UILabel!
    @IBOutlet weak var hotelAvailableRoomsLabel: UILabel!
    @IBOutlet weak var hotelLatLabel: UILabel!
    @IBOutlet weak var hotelLonLabel: UILabel!
    @IBOutlet weak var hotelStarsLabel: UILabel!
    var hotelInfo: HotelInfo!
    var hotelImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotelImageOutlet.image = hotelImage
        hotelNameLabel.text = hotelInfo.name
        hotelStarsLabel.text = String(hotelInfo.stars)
        hotelAddressLabel.text = hotelInfo.address
        hotelDistanceToCenterLabel.text = "\(hotelInfo.distance) meters to city center"
        hotelAvailableRoomsLabel.text = "\(getNumberAvailableRoomsFor(hotel: hotelInfo)) available rooms now"
        hotelLatLabel.text = String(hotelInfo.lat)
        hotelLonLabel.text = String(hotelInfo.lon)

        // Do any additional setup after loading the view.
    }
    
    func getNumberAvailableRoomsFor(hotel: HotelInfo) -> Int {
        let suitesAvailability = hotel.suitesAvailability
        return suitesAvailability.split(separator: ":").count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
