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

        if hotelImage.isSymbolImage {
            hotelImageOutlet.contentMode = .scaleAspectFit
        }

        hotelImageOutlet.image = hotelImage

        hotelNameLabel.text = hotelInfo.name
        hotelStarsLabel.text = String(hotelInfo.stars)
        hotelAddressLabel.text = hotelInfo.address
        hotelDistanceToCenterLabel.text = "\(hotelInfo.distance) meters to city center"
        hotelAvailableRoomsLabel.text = "\(hotelInfo.suitesAvailability.getNumberAvailableRooms()) available rooms now"
        hotelLatLabel.text = String(hotelInfo.lat)
        hotelLonLabel.text = String(hotelInfo.lon)
    }
}
